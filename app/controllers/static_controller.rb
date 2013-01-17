class StaticController < ApplicationController
  before_filter :login_required, :only => ["management"]

  def browser_not_supported
    respond_to do |format|
      format.html {render :layout => false}
    end	
  end

  def about
    respond_to do |format|
      format.html {render :layout => 'frontend'}
    end	
  end

  def past_projects
    respond_to do |format|
      format.html {render :layout => 'frontend'}
    end	
  end

  def management
  end

  def weblink_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end

  def primary_org_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end

  def student_dialog_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end	

  def organizational_collaboration_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end	  

  def affiliation_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end	  

  def page_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end

  def project_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end

  def page_photo_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end

  def project_photo_explanation
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end
end
