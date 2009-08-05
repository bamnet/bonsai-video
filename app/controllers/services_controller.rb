class ServicesController < ApplicationController

  def oembed
    id = params[:url].scan(/\/(\d+)$/i).first.first
    @video = Video.find(id)
    
    @thumbnail = @video.thumbnails.first
    @thumb_size = @thumbnail.guess_size('thumb')
    
    respond_to do |format|
      format.xml # oembed.xml.erb
      format.js # oembed.js.erb
    end
  end
end
