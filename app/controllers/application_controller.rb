# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  include FaceboxRender
  helper :all # include all helpers, all the time

  include Geokit::Geocoders

  layout 'backend'
  #before_filter :authenticate

  before_filter  :set_p3p
  before_filter :get_user
  after_filter :store_location

  protect_from_forgery :only => [:create, :update, :destroy] # See ActionController::RequestForgeryProtection for details

  rescue_from ActionController::InvalidAuthenticityToken, :with => :bad_token


  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def get_user
    @user = User.find(:first, :conditions => ['id = ? AND is_deleted = ?', session[:user_id], false] ) unless session[:user_id].nil?
    @user = @user ||= User.new
  end

  def has_access
    return true if current_user.is_admin?
    respond_to do |format|
      flash[:error] = "You do not have access to that page."
      format.html { redirect_back_or_default('/') }
      format.xml  { head :ok }
    end
  end

  def get_stats
    total_participants = 0
    total_organizations = []
    total_affiliated_organizations = []
    total_pre_school = 0
    total_elementary_school = 0
    total_middle_school = 0
    total_high_school = 0
    total_adults = 0
    total_mentors = 0
    total_locations = []

    current_selection_participants = 0
    current_selection_organizations = []
    current_selection_affiliated_organizations = []
    current_selection_pre_school = 0
    current_selection_elementary_school = 0
    current_selection_middle_school = 0
    current_selection_high_school = 0
    current_selection_adults = 0
    current_selection_mentors = 0
    current_selection_locations = []

    total_stats = Rails.cache.read('total_stats') || {}
    current_selection_stats = {}

    filtered_project_events = Rails.cache.read('filtered_project_events')
    current_selection = Rails.cache.read('current_selection')

    current_selection_obj = Project.find_by_name(current_selection)
    current_selection_obj = Page.find_by_name(current_selection) if current_selection_obj.blank?
    current_selection_events = []

    if current_selection_obj.class.name == "Project"
      current_selection_obj.pages.published.each {|page| current_selection_events << page.events.published}
      current_selection_events.flatten!
    else
      current_selection_events = current_selection_obj.events.published
    end

    current_selection_events.each do |event|
      next if event.blank? || event.location.blank? #TODO!
      loc = Location.find_by_name(event.location.first.name)
      current_selection_organizations << event.organization
      current_selection_organizations << event.connection_dialog
      current_selection_affiliated_organizations << event.affiliation
      current_selection_participants += event.total_participants
      current_selection_pre_school += event.pre_school
      current_selection_elementary_school += event.elementary_school
      current_selection_middle_school += event.middle_school
      current_selection_high_school += event.high_school
      current_selection_adults += event.adult
      current_selection_mentors += event.mentors
      current_selection_locations << [event.location.first.name,loc.lat,loc.lng]
    end

    filtered_project_events.each do |event|
      break unless total_stats.blank?
      next if event.blank? || event.location.blank? #TODO!
      loc = Location.find_by_name(event.location.first.name)
      total_organizations << event.organization
      total_organizations << event.connection_dialog
      total_affiliated_organizations << event.affiliation
      total_participants += event.total_participants
      total_pre_school += event.pre_school
      total_elementary_school += event.elementary_school
      total_middle_school += event.middle_school
      total_high_school += event.high_school
      total_adults += event.adult
      total_mentors += event.mentors
      total_locations << [event.location.first.name,loc.lat,loc.lng]
    end

    if total_stats.blank?
      total_stats[:total_organizations] = total_organizations.flatten.uniq.sort_by{|org| org.name}
      total_stats[:total_affiliated_organizations] = total_affiliated_organizations.flatten.uniq.sort_by{|affil_org| affil_org.name}
      total_stats[:total_participants] = total_participants
      total_stats[:total_pre_school] = total_pre_school
      total_stats[:total_elementary_school] = total_elementary_school
      total_stats[:total_middle_school] = total_middle_school
      total_stats[:total_high_school] = total_high_school
      total_stats[:total_adults] = total_adults
      total_stats[:total_mentors] = total_mentors
      total_stats[:total_locations] = total_locations.uniq

      # ignore certain orgs in the count
      total_stats[:total_organizations] = total_stats[:total_organizations].delete_if{|org| Event::IGNORE_IN_COUNTS.include?(org.name)}
      total_stats[:total_affiliated_organizations] = total_stats[:total_affiliated_organizations].delete_if{|org| Event::IGNORE_IN_COUNTS.include?(org.name)}

      Rails.cache.write('total_stats',total_stats)
    end

    current_selection_stats[:current_selection_organizations] = current_selection_organizations.flatten.uniq.sort_by{|org| org.name}
    current_selection_stats[:current_selection_affiliated_organizations] = current_selection_affiliated_organizations.flatten.uniq.sort_by{|affil_org| affil_org.name}
    current_selection_stats[:current_selection_participants] = current_selection_participants
    current_selection_stats[:current_selection_pre_school] = current_selection_pre_school
    current_selection_stats[:current_selection_elementary_school] = current_selection_elementary_school
    current_selection_stats[:current_selection_middle_school] = current_selection_middle_school
    current_selection_stats[:current_selection_high_school] = current_selection_high_school
    current_selection_stats[:current_selection_adults] = current_selection_adults
    current_selection_stats[:current_selection_mentors] = current_selection_mentors
    current_selection_stats[:current_selection_locations] = current_selection_locations.uniq

    # ignore certain orgs in the count
    current_selection_stats[:current_selection_organizations] = current_selection_stats[:current_selection_organizations].delete_if{|org| Event::IGNORE_IN_COUNTS.include?(org.name)}
    current_selection_stats[:current_selection_affiliated_organizations] = current_selection_stats[:current_selection_affiliated_organizations].delete_if{|org| Event::IGNORE_IN_COUNTS.include?(org.name)}

    respond_to do |format|
      format.html { render :json => [total_stats, current_selection_stats].to_json}
    end
  end

  def set_filter_session_variable
    session[:filter_type] = params[:filter_type]
    session[:filter_query] = params[:filter_query]
    Rails.cache.delete('total_stats')
    project = nil

    # Add new items to the filter drop down on the frontend
    if session[:filter_type] == "funder"
      project = Project.first(:select => "projects.name, funders.fullname, funders.id, pages.id, pages.is_published, pages.is_placeholder, pages.is_deleted", :order => 'projects.name ASC', :joins => [{:pages => :funders}], :conditions => ["funders.fullname = ? AND ((pages.is_published = ? AND pages.is_placeholder = ?) OR (pages.is_published = ? AND pages.is_placeholder = ?))", session[:filter_query], true, false, false, true])
    elsif session[:filter_type] == "age"
      query = session[:filter_query].downcase.gsub(/[- ]/,"_") #e.g. High School becomes high_school
      project = Project.first(:select => "projects.name, events.id, events.pre_school, events.elementary_school, events.middle_school, events.high_school, events.adult, events.mentors, pages.id, pages.is_placeholder, pages.is_deleted, pages.is_published", :order => 'projects.name ASC', :joins => [{:pages => :events}], :conditions => ["#{query} > ? and pages.is_published =?", 0, true])
    elsif session[:filter_type] == "project"
      project = Project.first(:conditions => ["name = ? and is_published = ?", session[:filter_query], true])
    elsif session[:filter_type] == "geo_scope"
      query = session[:filter_query].split(" ").first.downcase
      if query == "national"
        query = query.to_a
        query << "regional"
      end
      projects = []
      events = Event.tagged_with(query, :on => "geographic_scope", :any => true).published
      events.each { |event| projects << event.page.project if event.page.project.is_published }
      projects.uniq!
      projects = projects.sort_by{|project| project.name}
      project = projects.first unless projects.blank?
    else
      project = Project.first.published
    end

    response = project.nil? ? nil : "/#{$projects_name_replacement}/#{project.name.gsub(' ', '_')}"

    respond_to do |format|
      format.html { render :text => response }
    end
  end

  def get_involved
    #start_time = params[:start_time].to_f
    #now_time = Time.now.to_f*1000

    Mailer.deliver_contact_message(params[:name],params[:sender_email],params[:message],params[:project], params[:receiver_email])# if ((now_time - start_time) > 2000)
    respond_to do |format|
      format.html { render :text => "success" }
    end
  end


  private

    #modified store_location method as per
    #http://joshsharpe.com/archives/redirect-back-or-default-youre-probably-doing-it-wrong
    def store_location
      unless controller_name == "sessions" || action_name == "activate"
        session[:return_to] =
        if request.get?
          request.request_uri
        else
         request.referer
        end
      end
    end

  #maybe solves the ActionController::InvalidAuthenticityToken error in Internet Explorer
  def set_p3p
    response.headers["P3P"]='CP="CAO PSA OUR"'
  end

  def get_project_slider_info(selected_option_name)
    project_slider_html = ""
    projects = []
    pages = []
    events = []

    # Add new items to the filter drop down on the frontend
    if session[:filter_type] == "funder"
      pages = Page.all(:include => :funders, :conditions => ["funders.fullname = ? AND ((is_published = ? AND is_placeholder = ?) OR (is_published = ? AND is_placeholder = ?))", session[:filter_query], true, false, false, true])
      pages.each do |page|
        projects << page.project if page.project.is_published
        events << page.events.published
      end
      projects.uniq!
      projects = projects.sort_by{|project| project.name}
      events.flatten!
    elsif session[:filter_type] == "age"
      query = session[:filter_query].downcase.gsub(/[- ]/,"_")
      events = Event.all(:conditions => ["#{query} > ? and is_published =?", 0, true])
      events.each do |event|
        next unless event.page.project.is_published
        projects << event.page.project
        pages << event.page if event.page.is_published
      end
      projects.uniq!
      projects = projects.sort_by{|project| project.name}
      pages.uniq!
      pages = pages.sort_by{|page| page.name}
    elsif session[:filter_type] == "project"
      projects = Project.all(:conditions => ["name = ? and is_published = ?", session[:filter_query], true])
      pages = projects.first.pages
      pages.each {|page| events << page.events.published}
      events.flatten!
    elsif session[:filter_type] == "geo_scope"
      query = session[:filter_query].split(" ").first.downcase
      if query == "national"
        query = query.to_a
        query << "regional"
      end
      events = Event.tagged_with(query, :on => "geographic_scope", :any => true).published
      events.each do |event|
        next unless event.page.project.is_published
        projects << event.page.project
        pages << event.page if event.page.is_published
      end
      projects.uniq!
      projects = projects.sort_by{|project| project.name}
      pages.uniq!
      pages = pages.sort_by{|page| page.name}
    else
      projects = Project.published
      projects.each {|project| pages << project.pages}
      pages = pages.flatten.sort_by{|page| page.name}
      pages.uniq!
      pages.each {|page| events << page.events.published}
      events.flatten!
    end

    Rails.cache.write('filtered_project_events', events)

    projects.each do |project|
      project_name = project.name.gsub(' ','_')

      if project.project_image.blank?
        project_image_path = "/images/thumbnails/blank_big.jpg"
      else
        project_image_path = "#{project.project_image.image.url(:crop)}"
      end

      if project.name == selected_option_name || selected_option_name.blank?
        Rails.cache.write('current_selection',selected_option_name)
        project_slider_html += "<span id=\"section\" class=\"selected\" title=\"#{project.name}\">"
        project_slider_html += "<a href=\"/#{$projects_name_replacement}/#{project_name}\" class=\"viewing about\" title=\"#{project.name}\" style=\"background:url(#{project_image_path}) center no-repeat;\">"
      else
        project_slider_html += "<span id=\"section\" class=\"collapsed\" title=\"#{project.name}\">"
        project_slider_html += "<a href=\"/#{$projects_name_replacement}/#{project_name}\" class=\"about\" title=\"#{project.name}\" style=\"background:url(#{project_image_path}) center no-repeat;\">"
      end
      project_slider_html += "<p class=\"hovertitle\" style=\"width: 200px !important;\"><u>#{project.name}</u></p></a>"

      project_pages = project.pages.published.delete_if{|page| !pages.include?(page)}

      num_project_pages = project_pages.length
      project_pages.each_with_index do |page, page_index|
        page_name = page.name.gsub(' ','_')
        unless page.name == project.name
          if page.page_image.blank?
            page_image_path = "/images/thumbnails/blank_small.jpg"
          else
            page_image_path = "#{page.page_image.image.url(:crop)}"
          end

          if page.name == selected_option_name && page_index == num_project_pages - 1
            project_slider_html += "<a href=\"/#{$projects_name_replacement}/#{project_name}/#{$pages_name_replacement}/#{page_name}\" class=\"viewing lastthumb\" title=\"#{page.name}\" style=\"background:url(#{page_image_path}) center no-repeat;\">"
            Rails.cache.write('current_selection',selected_option_name)
          elsif page.name == selected_option_name
            project_slider_html += "<a href=\"/#{$projects_name_replacement}/#{project_name}/#{$pages_name_replacement}/#{page_name}\" class=\"viewing\" title=\"#{page.name}\" style=\"background:url(#{page_image_path}) center no-repeat;\">"
            Rails.cache.write('current_selection',selected_option_name)
          elsif page_index < num_project_pages-1
            project_slider_html += "<a href=\"/#{$projects_name_replacement}/#{project_name}/#{$pages_name_replacement}/#{page_name}\" title=\"#{page.name}\" style=\"background:url(#{page_image_path})  center no-repeat;\">"
          else
            project_slider_html += "<a href=\"/#{$projects_name_replacement}/#{project_name}/#{$pages_name_replacement}/#{page_name}\" class=\"lastthumb\" title=\"#{page.name}\" style=\"background:url(#{page_image_path}) center no-repeat;\">"
          end
          project_slider_html += "<p class=\"hovertitle\">#{page.name}</p></a>"
        end
      end

      project_slider_html += "</span>"
    end

    return project_slider_html

  end

  protected

    def authenticate
      redirect_to('/')
    end
end
