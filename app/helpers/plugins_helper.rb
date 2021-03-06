module PluginsHelper

	def has_update_span(plugin)
		if (plugin.has_update?)
			span = ' <span class="update label label-important">Has update</span>'
		else
			span = ' <span class="update label label-success">Up to date</span>'
		end
	end

	def create_search_result(plugin)
		html = '<li class="' + plugin.status + ' plugin-item">'
		span = has_update_span(plugin)
		span += ' <span class="update label label-warning">Inactive</span>' if (plugin.status === "inactive")
		version = ' <span class="version">(' + plugin.version + ')</span>'

		html += link_to plugin.name.titleize, [plugin.website.server, plugin.website, plugin]
		html += version + " on website " + plugin.website.name + span + '</li>'
	end

end
