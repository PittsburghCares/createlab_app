class FundersController < ApplicationController
  before_filter :login_required

  # GET /funders
  # GET /funders.xml
  def index
    @funders = Funder.paginate(:per_page => 10, :page => params[:page])

    if request.xhr?
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace_html 'table', :partial => "list_funders"
          end
        end
      end
    end
  end

  def list_funders
    sort = case params['sort']
      when "fullname"  then "fullname"
      when "name_reverse" then "fullname DESC"
    end

    @funders = Funder.paginate(:order => sort, :per_page => 10, :page => params[:page])

    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'table', :partial => "list_funders"
        end
      end
    end
  end

  # GET /funders/1
  # GET /funders/1.xml
  def show
    @funder = Funder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @funder }
    end
  end

  # GET /funders/new
  # GET /funders/new.xml
  def new
    @funder = Funder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @funder }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  #almost the same as below, but loads the facebox
  def new_facebox
    @funder = Funder.new

    respond_to do |format|
      format.html # new.html.erb
      format.js { render_to_facebox }
      format.xml  { render :xml => @funder }
    end
  end

  # GET /funders/1/edit
  def edit
    @funder = Funder.find(params[:id])
  end

  # POST /funders
  # POST /funders.xml
  def create
    @funder = Funder.new(params[:funder])

    respond_to do |format|
      if @funder.save
        format.html { redirect_to(@funder, :notice => 'Funder was successfully created.') }
        format.xml  { render :xml => @funder, :status => :created, :location => @funder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @funder.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_facebox
    @funder = Funder.new(params[:funder])

    respond_to do |format|
      if @funder.save
        @funders = Funder.find :all
        format.js {render :action => 'create.js.rjs'}
      else
        format.js
      end
    end
  end

  # PUT /funders/1
  # PUT /funders/1.xml
  def update
    @funder = Funder.find(params[:id])

    respond_to do |format|
      if @funder.update_attributes(params[:funder])
        format.html { redirect_to(@funder, :notice => 'Funder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @funder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /funders/1
  # DELETE /funders/1.xml
  def destroy
    @funder = Funder.find(params[:id])
    @funder.destroy
    #@funder.update_attribute("is_deleted", true)
    expire_fragment('all_funders')

    respond_to do |format|
      format.html { redirect_to(funders_url) }
      format.xml  { head :ok }
    end
  end
end
