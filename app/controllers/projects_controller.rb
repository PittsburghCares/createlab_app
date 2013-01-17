class ProjectsController < ApplicationController
  before_filter :login_required, :except => ["show", "index"]
  layout 'frontend', :only => ["show"]

  # GET /projects
  # GET /projects.xml
  def index
    #front end view used

    session[:filter_type] = nil
    session[:filter_query] = nil
    Rails.cache.delete('total_stats')

    #randomize what project a user sees when first going to the website
    #changes everyday at midnight
    @project = []

    if cookies[:landing_project].blank?
      rand_command = ActiveRecord::Base.connection.adapter_name.downcase.include?('mysql') ? "RAND()" : "RANDOM()" #RAND() for MySQL; RANDOM() for sqlite3
      @project = Project.exclude_multi_project.has_outreach.published.first(:order => rand_command)
      cookies[:landing_project] = { :value => @project.name, :expires => Time.now.midnight + 1.day} if @project
    else
      @project = Project.find_by_name(cookies[:landing_project])
    end

    if @project
      results = get_project_slider_info(@project.name)
      @project_slider_html = results
      @formatted_project_name = @project.name.gsub(' ','_')
    end

    respond_to do |format|
      format.html { redirect_to(:controller => 'projects', :action => 'show', :id => @formatted_project_name) }
      format.xml  { render :xml => @project }
    end
  end

  def list_projects
    #back end view used

    sort = case params['sort']
      when "name"  then "name"
      when "name_reverse" then "name DESC"
      when nil then "name"
    end

    @projects = Project.paginate(:order => sort, :per_page => 10, :page => params[:page])

    respond_to do |format|
      format.html {render :layout => 'backend'} # new.html.erb
      format.js do
        render :update do |page|
          page.replace_html 'table', :partial => "list_projects"
        end
      end
    end

  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @filter_type = session[:filter_type]
    @filter_query = session[:filter_query]

    params[:id] = params[:name] if params[:name]

    @project = Project.first(:conditions => ["lower(name) = ?", params[:id].downcase.gsub("_"," ").gsub("/","")])

    if @project.blank?
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
      return
    end

    results = get_project_slider_info(@project.name)
    @project_slider_html = results
    @formatted_project_name = @project.name.gsub(' ','_')

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    session[:from_page] = params[:from_page]
    session[:from_event] = params[:from_event]

    @project = Project.new
    @project.build_project_image
    @project.project_web_links.build
    @funders = Funder.all

    respond_to do |format|
      format.html {render :layout => 'backend'} # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @project.build_project_image if @project.project_image.blank?
    @funders = Funder.all
    @placeholder_page = @project.pages.first(:conditions => ["is_placeholder = ?", true]) 

    respond_to do |format|
      format.html {render :layout => 'backend'} # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @funders = Funder.all

    unless @project.has_outreach			
      @placeholder_page = Page.new
      params[:funder_ids].to_a.each do |funder_id|
        @placeholder_page.funders << Funder.find_by_id(funder_id)
      end
      @placeholder_page.name = "PLACEHOLDER PAGE - " + @project.name
      @placeholder_page.is_placeholder = true
      @placeholder_page.has_outreach = false
    end

    respond_to do |format|
      if @project.save

        unless @project.has_outreach
          @placeholder_page.project = @project
          @placeholder_page.save!
        end

        expire_fragment('all_projects')
        if params[:project][:project_image_attributes].blank? || params[:project][:project_image_attributes][:image].blank?
          if session[:from_event] && session[:from_page]
            session[:from_page] = nil
            flash[:notice] = "#{$projects_name_replacement.singularize.capitalize} was successfully created."
            format.html { redirect_to(:controller => 'pages', :action => 'new', :from_event => true)}
          elsif session[:from_page]
            session[:from_page] = nil
            format.html { redirect_to(new_page_path, :notice => "#{$projects_name_replacement.singularize.capitalize} was successfully created.") }
          else
            format.html { redirect_to( "/users/manage_#{$projects_name_replacement}", :notice => "#{$projects_name_replacement.singularize.capitalize} was successfully created.") }
          end
          format.xml  { render :xml => @project, :status => :created, :location => @project }
        else
          format.html { render :action => "crop_image", :layout => 'backend' }
        end
      else
        @project.build_project_image

        format.html { render :action => "new", :layout => 'backend' }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])
    @funders = Funder.all
    placeholder_page = Page.first(:conditions => ["project_id = ? AND is_placeholder = ?", @project.id, true])
    placeholder_page.destroy unless placeholder_page.blank?

    unless @project.has_outreach
      page = Page.new
      params[:funder_ids].to_a.each do |funder_id|
        page.funders << Funder.find_by_id(funder_id)
      end
      page.name = "PLACEHOLDER PAGE - " + @project.name
      page.project = @project
      page.is_placeholder = true
      page.has_outreach = false
      page.save!
    end

    respond_to do |format|
      if @project.update_attributes(params[:project])
        expire_fragment('all_projects')

        if params[:project][:project_image_attributes].blank? || params[:project][:project_image_attributes][:image].blank?
          if session[:from_event] && session[:from_page]
            session[:from_page] = nil
            flash[:notice] = "#{$projects_name_replacement.singularize.capitalize} was successfully created."
            format.html { redirect_to(:controller => 'pages', :action => 'new', :from_event => true) }
          elsif session[:from_page]
            session[:from_page] = nil
            format.html { redirect_to(new_page_path, :notice => "#{$projects_name_replacement.singularize.capitalize} was successfully created.") }
          else
            format.html { redirect_to( "/users/manage_#{$projects_name_replacement}", :notice => "#{$projects_name_replacement.singularize.capitalize} was successfully created.") }
          end
          format.xml  { head :ok }
        else
          format.html { render :action => "crop_image", :layout => 'backend' }
        end
      else
        format.html { render :action => "edit", :layout => 'backend' }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    #@project.destroy
    @project.update_attribute("is_deleted", true)
    expire_fragment('all_projects')

    respond_to do |format|
      format.html { redirect_to("/users/manage_#{$projects_name_replacement}") }
      format.xml  { head :ok }
    end
  end
end
