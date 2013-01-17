class PageImagesController < ApplicationController
  before_filter :login_required

  # GET /page_images
  # GET /page_images.xml
  def index
    @page_images = PageImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @page_images }
    end
  end

  # GET /page_images/1
  # GET /page_images/1.xml
  def show
    @page_image = PageImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page_image }
    end
  end

  # GET /page_images/new
  # GET /page_images/new.xml
  def new
    @page_image = PageImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page_image }
    end
  end

  # GET /page_images/1/edit
  def edit
    @page_image = PageImage.find(params[:id])
  end

  # POST /page_images
  # POST /page_images.xml
  def create
    @page_image = PageImage.new(params[:page_image])

    respond_to do |format|
      if @page_image.save
        format.html { redirect_to(@page_image, :notice => 'PageImage was successfully created.') }
        format.xml  { render :xml => @page_image, :status => :created, :location => @page_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /page_images/1
  # PUT /page_images/1.xml
  def update
    @page_image = PageImage.find(params[:id])

    respond_to do |format|
      if @page_image.update_attributes(params[:page_image])
        format.html { redirect_to(@page_image, :notice => 'PageImage was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /page_images/1
  # DELETE /page_images/1.xml
  def destroy
    @page_image = PageImage.find(params[:id])
    @page_image.destroy

    respond_to do |format|
      format.html { redirect_to(page_images_url) }
      format.xml  { head :ok }
    end
  end
end
