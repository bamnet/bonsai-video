class ThumbnailsController < ApplicationController
  
  downloads_files_for :thumbnail, :image, "inline"

  # GET /thumbnails
  # GET /thumbnails.xml
  def index
    @thumbnails = Thumbnail.find(:all, :conditions=>{:video_id => params[:video_id]}, :order=>:time)
    @video = Video.find(:first, :conditions=>{:id => params[:video_id]})
    
    if request.xhr?
       render :layout => false, :partial => 'grid', :locals => {:thumbnails => @thumbnails, :video => @video, :controls => true} and return
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @thumbnails }
      end
    end
  end

  # GET /thumbnails/new
  # GET /thumbnails/new.xml
  def new
    @thumbnail = Thumbnail.new
    @thumbnail.time = 0
    @thumbnail.video_id = params[:video_id]

    if request.xhr?
       render :layout => false,  :action => 'xhr_new'
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @thumbnail }
      end
    end
  end

  def create
    @thumbnail = Thumbnail.new(params[:thumbnail])
    @thumbnail.video_id = params[:video_id]
    @thumbnail.status = "Requested" if(@thumbnail.status.blank?)
    
          respond_to do |format|
      if @thumbnail.save
          ThumbnailWorker.asynch_generate(:thumbnail_id => @thumbnail.id)
          if request.xhr?
            @thumbnails = Thumbnail.find(:all, :conditions=>{:video_id => params[:video_id]})
            @video = Video.find(:first, :conditions=>{:id => params[:video_id]})
            render :layout => false, :partial => 'grid', :locals => {:thumbnails => @thumbnails, :video => @video, :controls=> true} and return
          end
          flash[:notice] = 'Thumbnail was successfully created.'
          format.html { redirect_to(video_thumbnails_path(@thumbnail.video)) }
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
