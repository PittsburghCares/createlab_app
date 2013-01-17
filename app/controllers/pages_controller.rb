class PagesController < ApplicationController
  before_filter :login_required, :except => ["show", "index"]
  layout 'frontend', :only => ["show"]

  #caches_page :show

  # GET /pages
  # GET /pages.xml
  def index
    #front end view used
    
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def list_pages
    #back end view used

    sort = case params['sort']
      when "name"  then "name"
      when "name_reverse" then "name DESC"
      when nil then "name"
    end

    @pages = Page.paginate(:order => sort, :conditions => ["is_placeholder = ?", false], :per_page => 10, :page => params[:page])

    respond_to do |format|
      format.html {render :layout => 'backend'}
      format.js do
        render :update do |page|
          page.replace_html 'table', :partial => "list_pages"
        end
      end
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @filter_type = session[:filter_type]
    @filter_query = session[:filter_query]
    params[:id] = params[:name] if params[:name]

    @page = Page.first(:conditions => ["lower(name) = ?", params[:id].downcase.gsub("_"," ").gsub("/","")])

    if @page.blank? || @page.project.name.downcase.gsub("_"," ").gsub("/","") != params[:project_id].downcase.gsub("_"," ").gsub("/","")
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
      return
    end

    results = get_project_slider_info(@page.name)
    @project_slider_html = results
    @formatted_project_name = @page.project.name.gsub(' ','_')
    @formatted_page_name = @page.name.gsub(' ','_')

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    session[:from_event] = params[:from_event]

    @page = Page.new
    @page.build_page_image
    @page.page_web_links.build
    @funders = Funder.all

    respond_to do |format|
      format.html {render :layout => 'backend'}
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
    @page.build_page_image if @page.page_image.blank?

    @funders = Funder.all
    respond_to do |format|
      format.html {render :layout => 'backend'}
      format.xml  { render :xml => @page }
    end
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
    @funders = Funder.all

    params[:funder_ids].to_a.each do |funder_id|
    @page.funders << Funder.find_by_id(funder_id)
    end

    respond_to do |format|
      if @page.save
        if params[:page][:page_image_attributes].blank? || params[:page][:page_image_attributes][:image].blank?
          if session[:from_event]
            session[:from_event] = nil
            format.html { redirect_to(new_event_path, :notice => "#{$pages_name_replacement.singularize.capitalize} was successfully created.") }
          else
            format.html { redirect_to("/users/manage_#{$pages_name_replacement}", :notice => "#{$pages_name_replacement.singularize.capitalize} was successfully created.") }
          end        	
          format.xml  { render :xml => @page, :status => :created, :location => @page }
        else
          format.html { render :action => "crop_image", :layout => 'backend' }
        end
      else
        @page.build_page_image
        format.html { render :action => "new", :layout => 'backend' }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])
    @funders = Funder.all
    @page.funders.clear if params[:funder_ids]
    params[:funder_ids].to_a.each do |funder_id|
      @page.funders << Funder.find_by_id(funder_id)
    end
    respond_to do |format|
      if @page.update_attributes(params[:page])
        if params[:page][:page_image_attributes].blank? || params[:page][:page_image_attributes][:image].blank?
          if session[:from_event]
            format.html { redirect_to(new_event_path, :notice => "#{$pages_name_replacement.singularize.capitalize} was successfully created.") }
          else
            format.html { redirect_to("/users/manage_#{$pages_name_replacement}", :notice => "#{$pages_name_replacement.singularize.capitalize} was successfully updated.") }
          end
          format.xml  { head :ok }        
        else
          format.html { render :action => "crop_image", :layout => 'backend' }
        end      
      else
        format.html { render :action => "edit", :layout => 'backend' }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    #@page.destroy
    @page.update_attribute("is_deleted", true)
    @page.events.update_all :is_deleted => true

    respond_to do |format|
      format.html { redirect_to('/users/manage_#{$pages_name_replacement}') }
      format.xml  { head :ok }
    end
  end
end
