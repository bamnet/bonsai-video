class ThumbnailsController < ApplicationController
  
  downloads_files_for :thumbnail, :image, "inline"

  # GET /thumbnails
  # GET /thumbnails.xml
  def index
    @thumbnails = Thumbnail.find(:all, :conditions=>{:video_id => params[:video_id]})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @thumbnails }
    end
  end

  # GET /thumbnails/1
  # GET /thumbnails/1.xml
  def show
    @thumbnail = Thumbnail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @thumbnail }
    end
  end

  # GET /thumbnails/new
  # GET /thumbnails/new.xml
  def new
    @thumbnail = Thumbnail.new
    @thumbnail.time = 0
    @thumbnail.video_id = params[:video_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @thumbnail }
    end
  end

  # POST /thumbnails
  # POST /thumbnails.xml
  def create
    @thumbnail = Thumbnail.new(params[:thumbnail])
    @thumbnail.video_id = params[:video_id]

      respond_to do |format|
      if @thumbnail.save
          MiddleMan.worker(:thumbnail_worker).enq_queue_thumbnail(:args => {:thumbnail_id => @thumbnail.id}, :job_key => @thumbnail.id)
          flash[:notice] = 'Thumbnail was successfully created.'
          format.html { redirect_to(video_thumbnail_path(@thumbnail.video, @thumbnail)) }
          format.xml  { render :xml => @thumbnail, :status => :created, :location => @thumbnail }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @thumbnail.errors, :status => :unprocessable_entity }
        end
      end
  end

  # DELETE /thumbnails/1
  # DELETE /thumbnails/1.xml
  def destroy
    @thumbnail = Thumbnail.find(params[:id])
    @thumbnail.destroy

    respond_to do |format|
      format.html { redirect_to(video_thumbnails_url) }
      format.xml  { head :ok }
    end
  end
end
