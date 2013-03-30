class EventsController < ApplicationController
  before_filter :login_required

  def auto_complete_for_event_tag
    @tags = Event.find_tags(params[:tag], ["tag"], nil, 10)

    if @tags.blank?
      not_found_message
    else
      render :partial => "auto_complete_for_event_tag"
    end  
  end

  def auto_complete_for_event_organization
    @organizations = Event.find_tags(params[:organization], ["organization", "affiliation", "connection_dialog"], nil, 10)

    if @organizations.blank?
      not_found_message
    else
      render :partial => "auto_complete_for_event_organization"
    end
  end

  def auto_complete_for_event_affiliation
    @affiliations = Event.find_tags(params[:affiliation], ["organization", "affiliation", "connection_dialog"], nil, 10)

    if @affiliations.blank?
      not_found_message
    else
      render :partial => "auto_complete_for_event_affiliation"
    end
  end

  def auto_complete_for_event_connection_dialog
    @connection_dialogs = Event.find_tags(params[:connection_dialog], ["organization", "affiliation", "connection_dialog"], nil, 10)

    if @connection_dialogs.blank?
      not_found_message
    else
      render :partial => "auto_complete_for_event_connection_dialog"
    end
  end

  def auto_complete_for_event_location
    @locations = Event.find_tags(params[:location], ["location"], nil, 10)

    if @locations.blank?
      not_found_message
    else
      render :partial => "auto_complete_for_event_location"
    end
  end

  def not_found_message
    @message = "<span id='message_validation'><small>No match. This entry will be created when the form is submitted.</small></span>"
    respond_to do |format|
      format.js do
        render :update do |page|
          page.call('insert_message_validation',@message,params[:auto_complete_id])
        end
      end
    end
  end

  def clear_message
  @message = ""
    respond_to do |format|
      format.js do
        render :update do |page|
          page.call('remove_message_validation')
        end
      end
    end
  end

  def show_hide_page_fields
    @page = Page.find(params[:page_id])
    respond_to do |format|
      format.js do
        render :update do |page|
          page.call('hide_page_related_fields')
            if @page.has_student_dialogues
            page.call('show_student_dialogues_field')
          else
            #things are already hidden, so do not do anything
            #page.call('hide_page_related_fields')
          end
        end
      end
    end
  end

  # GET /events
  # GET /events.xml
  def index
    if params[:page].blank?
      session[:search_type] = nil
      session[:search_query] = nil
    end

    contexts = session[:search_type] == "all" ? ["organization", "location", "arena", "geographic_scope", "connection_dialog", "affiliation", "tag"] : session[:search_type]

    if session[:search_query].blank?
      @events = Event.all 
    elsif session[:search_type].include?("page") || session[:search_type].include?("project") || session[:search_type] == "name"
      @events = Event.find(:all, :conditions => ["#{session[:search_type]} LIKE ?", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
    elsif session[:search_type] == "all"
      @events = Event.tagged_with("#{session[:search_query]}%", :any => true)
    else
      @events = Event.tagged_with("#{session[:search_query]}%", :on => "#{session[:search_type]}", :any => true)
    end

    @events = @events.paginate(:per_page => session[:per_page], :page => params[:page])

    if request.xhr?
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace_html 'table', :partial => "list_events"
          end
        end
      end
    end
  end

  def list_events
    params['sort'] ||= ""

    session[:search_type] = params[:search_type]
    session[:search_query] = params[:search_query]
    session[:per_page] = params[:per_page].blank? ? 10 : params[:per_page]


    if session[:search_query].blank?
      @events = Event.all
    elsif session[:search_type].include?("page") || session[:search_type].include?("project") || session[:search_type] == "name"
      @events = Event.find(:all, :conditions => ["#{session[:search_type]} LIKE ?", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
    elsif session[:search_type] == "all"
      @events = Event.tagged_with("#{session[:search_query]}%", :any => true)
      @events += Event.find(:all, :conditions => ["projects.name LIKE ? OR pages.name LIKE ?", "%#{session[:search_query]}%", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
      @events += Event.find(:all, :conditions => ["name LIKE ?", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
    else
      @events = Event.tagged_with("#{session[:search_query]}%", :on => "#{session[:search_type]}", :any => true)
    end

    #i really do not like how we sort here...
    if params['sort'].include?("name")
      orig_events = @events.dup
      @events.delete_if {|a| a.page.blank? }
      if params['sort'] == "name"
        @events = @events.sort_by { |a| a.name.to_s }
        @events = (@events + orig_events).uniq
      else
        @events = @events.sort_by { |a| a.name.to_s }.reverse!
        @events = (@events + orig_events).uniq
      end
    elsif params['sort'].include?("project")
      orig_events = @events.dup
      @events.delete_if {|a| a.page.blank? }
      if params['sort'] == "project"
        @events = @events.sort_by { |a| a.page.project.name }
        @events = (@events + orig_events).uniq
      else
        @events = @events.sort_by { |a| a.page.project.name }.reverse!
        @events = (@events + orig_events).uniq
      end
    elsif params['sort'].include?("organization")
      orig_events = @events.dup
      @events.delete_if {|a| a.page.blank? || a.organization.first.blank?}
      if params['sort'] == "organization"
        @events = @events.sort_by { |a| a.organization.first.name }
        @events = (orig_events + @events).uniq
      else
        @events = @events.sort_by { |a| a.organization.first.name }.reverse!
        @events = (@events + orig_events).uniq
      end 
    elsif params['sort'].include?("location")
      orig_events = @events.dup
      @events.delete_if {|a| a.page.blank? || a.location.first.blank? }
      if params['sort'] == "location"
        @events = @events.sort_by { |a| a.location.first.name }
        @events = (orig_events + @events).uniq
      else
        @events = @events.sort_by { |a| a.location.first.name }.reverse!
        @events = (@events + orig_events).uniq
      end    
    elsif params['sort'].include?("page")
      orig_events = @events.dup
      @events.delete_if {|a| a.page.blank? }
      if params['sort'] == "page"
        @events = @events.sort_by { |a| a.page.name }
        @events = (@events + orig_events).uniq
      else		
        @events = @events.sort_by { |a| a.page.name }.reverse!
        @events = (@events + orig_events).uniq
      end
    elsif params['sort'].include?("status")
      orig_events = @events.dup
      @events.delete_if {|a| a.page.blank?}					
      if params['sort'] == "status"
        @events = @events.sort_by { |a| a.is_published.to_s }
        @events = (@events + orig_events).uniq
      else
        @events = @events.sort_by { |a| a.is_published.to_s }.reverse!
        @events = (@events + orig_events).uniq
      end 
    else
      @events.uniq!
    end

    @events = @events.paginate(:per_page => session[:per_page], :page => params[:page])

    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'table', :partial => "list_events"
        end
      end
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    #@pages = Page.all
    @projects_pages = []
    projects = Project.all.sort{|a,b| a.name <=> b.name}
    projects.each do |project|
      @projects_pages << ["#{project.name}", project.pages.exclude_placeholder] unless project.pages.blank?
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @projects_pages = []
    projects = Project.all.sort{|a,b| a.name <=> b.name}
    projects.each do |project|
      @projects_pages << ["#{project.name}", project.pages.exclude_placeholder] unless project.pages.blank?
    end
  end

  # POST /events
  # POST /events.xml
  def create
    @projects_pages = []
    projects = Project.all.sort{|a,b| a.name <=> b.name}
    projects.each do |project|
      @projects_pages << ["#{project.name}", project.pages.exclude_placeholder] unless project.pages.blank?
    end

    @event = Event.new(params[:event])

    @event.is_published = true unless params[:is_published].blank?

    params[:connection_dialogs].values.each { |value| @event.connection_dialog_list << value.strip unless value.blank? } if params[:connection_dialogs]
    params[:organizations].values.each { |value| @event.organization_list << value.strip unless value.blank? } if params[:organizations]
    params[:affiliations].values.each { |value| @event.affiliation_list << value.strip unless value.blank? } if params[:affiliations]
    #arenas comes in as a HashWithIndifferentAccess
    params[:arenas][0].to_hash.values.each { |value| @event.arena_list << value.strip unless value.blank?} if params[:arenas]
    params[:tags].values.each { |value| @event.tag_list << value.strip unless value.blank? } if params[:tags]
    #web_links comes in as a HashWithIndifferentAccess
    params[:web_links][0].to_hash.values.each { |value| @event.web_link_list << value.strip unless value.blank? } if params[:web_links]

    event_users = []
    event_users << current_user

    @event.errors.add(:location, "can't be blank" ) if params[:event][:location].first.blank?

    respond_to do |format|
      if @event.errors.empty? && @event.save
        expire_fragment('all_funders')
        expire_fragment('all_projects')
        Rails.cache.delete('total_stats')

        event_users += User.all(:include => :projects, :conditions => ["projects.id = ?", @event.page.project.id])
        event_users.uniq!
        @event.users << event_users				
        @event.save!

        unless @event.location.first.blank?
          location = Location.find_by_name(@event.location.first.name)
          unless location
            location = Location.new
            location.name = @event.location.first.name
            sleep(1) #ensure requests are made only once per second, in the event we are flooded with form submissions. Google gets mad if requests are too frequent
            res=Geokit::Geocoders::MultiGeocoder.geocode("#{location.name}")
            location.lat = res.lat
            location.lng = res.lng
            location.save!
          end
        end

        session[:from_event] = nil
        session[:from_page] = nil
        flash[:notice] = @event.is_published? ? "Event was successfully created." : "The draft of this event was successfully created."
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update

    @projects_pages = []
    projects = Project.all.sort{|a,b| a.name <=> b.name}
    projects.each do |project|
      @projects_pages << ["#{project.name}", project.pages.exclude_placeholder] unless project.pages.blank?
    end

    @event = Event.find(params[:id])

    @event.organization_list.clear
    @event.location_list.clear
    @event.arena_list.clear
    @event.geographic_scope_list.clear
    @event.connection_dialog_list.clear
    @event.affiliation_list.clear
    @event.tag_list.clear
    @event.web_link_list.clear

    @event.is_published = true unless params[:is_published].blank?

    params[:connection_dialogs].values.each { |value| @event.connection_dialog_list << value.strip unless value.blank? } if params[:connection_dialogs]
    params[:organizations].values.each { |value| @event.organization_list << value.strip unless value.blank? } if params[:organizations]
    params[:affiliations].values.each { |value| @event.affiliation_list << value.strip unless value.blank? } if params[:affiliations]
    #arenas comes in as a HashWithIndifferentAccess
    params[:arenas][0].to_hash.values.each { |value| @event.arena_list << value.strip unless value.blank? } if params[:arenas]
    params[:tags].values.each { |value| @event.tag_list << value.strip unless value.blank? } if params[:tags]
    #arenas comes in as a HashWithIndifferentAccess
    params[:web_links][0].to_hash.values.each { |value| @event.web_link_list << value.strip unless value.blank? } if params[:web_links]

    respond_to do |format|
      if @event.update_attributes(params[:event])

        unless @event.location.first.blank?
          location = Location.find_by_name(@event.location.first.name)
          unless location
            location = Location.new
            location.name = @event.location.first.name
            sleep(1) #ensure requests are made only once per second, in the event we are flooded with form submissions. Google gets mad if requests are too frequent
            res=Geokit::Geocoders::MultiGeocoder.geocode("#{location.name}")
            location.lat = res.lat
            location.lng = res.lng
            location.save!
          end
        end

        expire_fragment('all_funders')
        expire_fragment('all_projects')
        Rails.cache.delete('total_stats')

        flash[:notice] = @event.is_published? ? "Event was successfully updated." : "The draft of this event was successfully updated."
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    #@event.destroy
    @event.update_attribute("is_deleted", true)

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
