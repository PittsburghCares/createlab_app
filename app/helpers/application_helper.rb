# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def custom_flash(message)
		flash[:notice] = "#{message}"
	end

	#for custom attributes (done to handle multiple fields with is_taggable_on plugin)
  def add_child_link(name, child, form_builder, image)
    fields = escape_javascript(new_child_fields(form_builder, child))
  	link_to_function(image_tag("/images/#{image}", :border=>"0", :alt=>"Add More", :title=>"#{name}"), h("add_child(this, \"#{child}\", \"#{fields}\")"))
  end

	#for actual nested_attributes
  def add_child_link2(name, child, form_builder, image)
    fields = escape_javascript(new_child_fields2(child, form_builder))
    link_to_function(image_tag("/images/#{image}", :border=>"0", :alt=>"Add More", :title=>"#{name}"), h("add_child(this, \"#{child}\", \"#{fields}\")"))
  end
  
  #for custom attributes (done to handle multiple fields with is_taggable_on plugin)
  def new_child_fields(form_builder, method, options = {})  
    options[:partial] ||= method.to_s.singularize  
    options[:form_builder_local] ||= :f  
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|  
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f, :child_id => 0, :value => "" })  
    end  
  end

	#for actual nested_attributes
  def new_child_fields2(child, form_builder)
    form_builder.fields_for(child.pluralize.to_sym, child.camelize.constantize.new, :child_index => 'NEW') do |f|
      render(:partial => child.underscore, :locals => { :f => f, :child_id => 0, :value => "" })
    end
  end

  def remove_child_link(name, form_builder)
    link_to_function(image_tag('/images/cancel.png', :border=>"0", :alt=>"Remove", :title=>"Remove"), "remove_child(this)")
  end

  def remove_child_link2(name, form_builder)
    form_builder.hidden_field(:_destroy) + link_to_function(image_tag('/images/cancel.png', :border=>"0", :alt=>"Remove", :title=>"Remove"), "remove_child2(this)")
  end
  
  def delimted_funders_list(list, delimiter)
  	output = ""
  	count = list.size - 1
  	list.each_with_index do |item, i|
  		output += item.name
  		output += delimiter unless i == count
  	end
  	output
  end

	def sort_td_class_helper(param)
		result = 'class="sortup"' if params[:sort] == param
		result = 'class="sortdown"' if params[:sort] == param + "_reverse"
		return result
	end

	def sort_link_helper(text, param, controller_action, div_id)
		key = param
		key += "_reverse" if params[:sort] == param || params[:sort].blank?
		options = {
			:url => {:action => controller_action, :params => params.merge({:sort => key, :page => nil, :action => controller_action})},
			#:update => div_id,
			:before => "Element.show('spinner')",
			:success => "Element.hide('spinner')"
		}
		html_options = {
			:title => "Sort by this field",
			:href => url_for(:action => controller_action, :params => params.merge({:sort => key, :page => nil, :action => controller_action}).except(:authenticity_token))
		}
		link_to_remote(text, options, html_options)
	end

  def current_user
    controller.current_user
  end

  def logged_in?
    controller.logged_in?
  end

  def tags
    find_tags("tag")
  end

  def affiliations
    find_tags("affiliation")
  end

  def connection_dialogs
    find_tags("connection_dialog")
  end

  def geographic_scopes
    find_tags("geographic_scope")
  end

  def arenas 
    find_tags("arena")
  end

  def locations 
    find_tags("location")
  end

  def organizations
    find_tags("organization")
  end
  
  def organizations_and_roles
  	list = organizations + connection_dialogs + affiliations
  	list.sort!
  	list
  end

  private
  def find_tags(context)
    ActiveRecord::Base.connection.execute(
      "SELECT DISTINCT tags.name 
         FROM tags 
   INNER JOIN taggings ON taggings.tag_id = tags.id 
        WHERE taggings.context = '#{context}'"
    ).map {|t| t["name"] }

  end

end
