class UsersController < ApplicationController
  before_filter :login_required, :except => ["new", "create", "activate", "forgot_password", "reset_password"]

  # render new.rhtml
  def new
    @user = User.new
  end

  def edit
    @user = get_user
  end

  def manage_profile
    @user = User.find_by_id(current_user.id)
    @projects = Project.all
  end

  # GET /events
  # GET /events.xml
  def manage_events
    @user = User.find_by_id(current_user.id)

    params['sort'] ||= ""

    if params[:page].blank?
      session[:search_type] = nil
      session[:search_query] = nil
    end

    if session[:search_query].blank?
      @events = @user.events
    elsif session[:search_type].include?("page") || session[:search_type].include?("project") || session[:search_type] == "name"
      @events = @user.events.find(:all, :conditions => ["#{session[:search_type]} LIKE ?", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
    else
      @events = @user.events.tagged_with("%#{session[:search_query]}%", :on => "#{session[:search_type]}", :any => true)
    end
    @events.uniq!
    @events = @events.paginate(:per_page => session[:per_page], :page => params[:page])

    if request.xhr?
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace_html 'table', :partial => "events/list_events"
          end
        end
      end 
    end
  end

  def list_events
    @user = User.find_by_id(current_user.id)

    params['sort'] ||= ""

    session[:search_type] = params[:search_type]
    session[:search_query] = params[:search_query]
    session[:per_page] = params[:per_page].blank? ? 10 : params[:per_page]

    if session[:search_query].blank?
      @events = @user.events
    elsif session[:search_type].include?("page") || session[:search_type].include?("project") || session[:search_type] == "name"
      @events = @user.events.find(:all, :conditions => ["#{session[:search_type]} LIKE ?", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
    elsif session[:search_type] == "all"
      @events = @user.events.tagged_with("#{session[:search_query]}%", :any => true)
      @events += @user.events.find(:all, :conditions => ["projects.name LIKE ? OR pages.name LIKE ?", "%#{session[:search_query]}%", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
      @events += @user.events.find(:all, :conditions => ["name LIKE ?", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
    else
      @events = @user.events.tagged_with("%#{session[:search_query]}%", :on => "#{session[:search_type]}", :any => true)
      @events += @user.events.find(:all, :conditions => ["projects.name or pages.name LIKE ?", "%#{session[:search_query]}%"], :include => [:page, {:page => :project}])
    end

    #i really do not like how we sort here...not sure of another way with this db setup... 		
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
    end
    #else
    #  @events.uniq!
    #end
    @events.uniq!

    @events = @events.paginate(:per_page => session[:per_page], :page => params[:page])

    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'table', :partial => "events/list_events"
        end
      end
    end
  end

  def change_password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      @user = User.find_by_id(current_user.id)
      @user.password_confirmation = params[:user][:password_confirmation]
      @user.password = params[:user][:password]

      respond_to do |format|
        if @user.save
          #self.current_user = @user #for the next two lines to work
          format.html { redirect_to(user_path(current_user), :notice => 'Password has been successfully reset.') }
        else
          format.html { render :action => 'change_password' }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = "Old password incorrect." 
    end
  end

  #gain email address
  def forgot_password
    return unless request.post?
    if @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      redirect_back_or_default('/')
      flash[:notice] = "A password reset link has been sent to your email address." 
    else
      flash[:error] = "Could not find a user with that email address." 
    end
  end

  #reset password
  def reset_password
    @user = User.find_by_password_reset_code(params[:id])
    return if @user unless params[:user]

    @user.reset_password
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.password = params[:user][:password]

    respond_to do |format|
      if @user.save
        self.current_user = @user #for the next two lines to work
        format.html { redirect_to(user_path(current_user), :notice => 'Password has been successfully reset. You have been automatically logged in.') }
      else
        format.html { render :action => 'reset_password' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    redirect_to('/management')
  end

  def create
    #logout_keeping_session!
    @user = User.new(params[:user])
    role = Role.find_by_name("user")
    @user.roles << role

    if @user.save
      flash[:notice] = "Thank you for registering. Once your account has been confirmed, you'll receive an email to complete the registration."
      redirect_to('/management')
    else
      render :action => 'new'
    end
  end

  # PUT /meta_datas/1
  # PUT /meta_datas/1.xml
  def update
    project_ids = params[:user].blank? || params[:user][:project_ids].blank? ? [] : params[:user][:project_ids]
    @user = User.find(params[:id])
    unless project_ids.blank?
      @user.projects.clear
      @user.events.clear
      project_ids.each do |project_id|
      @user.projects << Project.find_by_id(project_id)
      Event.all.each {|event| @user.events << event unless event.page.blank? || event.page.project.id.to_s != project_id.to_s }
    end
    user_events = Event.find_all_by_user_id(@user.id)
    user_events.each {|event| @user.events << event unless event.blank? || @user.events.include?(event)} unless user_events.blank? #if we want to keep an event that a user created, even though that user may no longer be part of that project
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your account information was successfully updated.' 
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Registration complete! The user will receive an email informing of the account activation."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing. Please follow the URL from your email."
      #redirect_back_or_default('/')
      redirect_to '/login'
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      #redirect_back_or_default('/')
      redirect_to '/login'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])

    #don't actually delete the story from the db, just mark it as removed
    if @user.is_deleted
      @user.update_attribute("is_deleted", false)
      flash[:notice] = "User is no longer marked as deleted."
    else
      @user.update_attribute("is_deleted", true)
      flash[:notice] = "User was successfully marked as deleted."
    end

    #@user.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

end
