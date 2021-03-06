class PluginsController < ApplicationController
  before_filter :load_server, :load_website
  add_breadcrumb "Home", :root_path

  # GET /plugins
  # GET /plugins.json
  def index
    @plugins = Plugin.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plugins }
    end
  end

  # GET /plugins/1
  # GET /plugins/1.json
  def show
    @plugin = Plugin.find(params[:id])
    add_breadcrumb @server.name, [@server]
    add_breadcrumb @website.name, [@server, @website]
    add_breadcrumb @plugin.name, [@server, @website, @plugin]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plugin }
    end
  end

  # GET /plugins/1/description
  # GET /plugins/1/description.js
  def description
    @plugin = Plugin.find(params[:id])
    @info   = @plugin.wp_info

    respond_to do |format|
      format.html
      format.js
      format.json { render json: { plugin: @plugin, info: @info } }
    end
  end

  # GET /plugins/new
  # GET /plugins/new.json
  def new
    @plugin = Plugin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plugin }
    end
  end

  # GET /plugins/1/edit
  def edit
    @plugin = Plugin.find(params[:name])
  end

  # POST /plugins
  # POST /plugins.json
  def create
    @plugin = Plugin.new(params[:plugin])

    respond_to do |format|
      if @plugin.save
        format.html { redirect_to [@server, @website, Plugin], notice: 'Plugin was successfully created.' }
        format.json { render json: @plugin, status: :created, location: @plugin }
      else
        format.html { render action: "new" }
        format.json { render json: @plugin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plugins/1
  # PUT /plugins/1.json
  def update
    @plugin = Plugin.find(params[:name])

    respond_to do |format|
      if @plugin.update_attributes(params[:plugin])
        format.html { redirect_to [@server, @website, @plugin], notice: 'Plugin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plugin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plugins/1
  # DELETE /plugins/1.json
  def destroy
    @plugin = Plugin.find(params[:name])
    @plugin.destroy

    respond_to do |format|
      format.html { redirect_to plugins_url }
      format.json { head :no_content }
    end
  end
end
