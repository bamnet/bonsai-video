class VideosController < ApplicationController
  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.find(:all, :conditions => {:parent_id => nil}, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])
    @profiles = Profile.find(:all);
    @conversion = Conversion.new({:video_id => @video.id})
    
    #All conversion options
    path = "app/views/videos/playback"
    @players = Dir.glob("#{path}/**")
    @players.map! {|f| File.basename(f, File.extname(f)).reverse.chop.reverse}

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.xml
  def new
    @video = Video.new
    
    #Figure out if there are any importable videos
    path = "import"
    @importable = Dir.glob("#{path}/**")
    @importable.map! {|f| [f.sub(path + "/", ""), f]}

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.xml
  def create
    @video = Video.new(params[:video])
    
    #Attempt to read some properties
    if params[:video][:import].blank?
      logger.debug("Importing from upload")
      tmp_path = params[:video][:asset].local_path
      @video.populate_meta_data tmp_path
    else
      tmp_path = Dir.pwd + "/" + params[:video][:import]
      logger.debug("Importing from disk #{tmp_path}")
      @video.populate_meta_data tmp_path
      @video.asset = File.new(tmp_path)
    end
    
    respond_to do |format|
      if @video.save
        flash[:notice] = 'Video was successfully created.'
        format.html { redirect_to(@video) }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])
    
    respond_to do |format|
      if @video.update_attributes(params[:video])
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to(@video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /videos/1/embed
  def embed
    @video = Video.find(params[:id])
    if params[:player].nil?
      render :partial => 'videos/playback/handler', :locals => {:video => @video}
    else
      player ='videos/playback/' + params[:player].gsub( /\W/, '')
      if player == 'videos/playback/video_for_everyone'
        best_ogg = @video.best('OGG', 'Theora')
        best_mp4 = @video.best('MPEG-4', 'AVC')
        if !best_ogg.blank? && !best_mp4.blank?
          render :partial => player, :locals => {:best_mp4 => best_mp4, :best_ogg => best_ogg, :video => @video}
        else
          render :text => "Unavailable for this video.  Ensure mp4 and ogg conversions exist."
        end
      else
        render :partial => player, :locals => {:video => @video}
      end
    end
  end
  
  # GET /videos/dl/1/Sample.avi
  def dl
      video = Video.find(params[:id])
      #Adjust mime types to please browsers
      if video.asset_content_type == 'application/x-ogv'
        content_type = 'video/ogg'
      else
        content_type = video.asset_content_type
      end
      #Increment the file counter
      Video.increment_counter(:view_count, video.id)
      send_file video.asset.path, :type => content_type
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end
end
