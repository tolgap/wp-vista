class Website < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  attr_accessible :name, :version, :has_update, :blog_name,
    :has_errors, :website_errors, :plugin, :cms_type, :comments,
    :has_maintenance

  index_name "#{Rails.application.class.parent_name.downcase}_#{Rails.env}_websites"

  mapping do
    indexes :name, analyzer: 'snowball'
    indexes :version, analyzer: 'snowball'
    indexes :has_update, type: :boolean
    indexes :has_error, type: :boolean
    indexes :cms_type, type: :string
  end

  belongs_to :server
  has_many :plugins

  serialize :website_errors

  # Instance methods
  def has_plugin_update
    update_info = plugins.map { |p| p.status == "active" && p.has_update? }
    update_info.include?(true)
  end

  def has_update_by_type?
    if cms_type == 'drupal'
      core = plugins.find_by_name('drupal')
      core.blank? ? true : core.has_update?
    else
      has_update?
    end
  end

  def clean_errors
    website_errors.reject(&:blank?)
  end

  # Class methods
  class << self

    def has_plugin(plugin)
      Plugin.where('plugins.name = ? AND plugins.id != ?', plugin.name, plugin.id)
        .includes(:website)
        .where('websites.has_errors = ?', false)
    end

    def check_latest_wp_version
      require "net/http"
      require "php_serialize"
      url = URI.parse('http://api.wordpress.org/core/version-check/1.6')
      r = Net::HTTP.get_response(url)
      if r.code == "301"
          url = URI.parse(r.header['location'])
      end

      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }

      result = PHP.unserialize(res.body)
      result['offers'].first['current']
    end

  end
end
