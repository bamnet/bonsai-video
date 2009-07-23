class ThumbnailWorker < Workling::Base
  #Generate a thumbnail
  def generate(args = nil)
    logger.info("Calling generate method for thumbnail #{args[:thumbnail_id]}.")
    thumbnail = Thumbnail.find(args[:thumbnail_id])
    if thumbnail.time > thumbnail.video.duration
      thumbnail.update_attributes({:status => "failed"})
      return false
    end
    thumbnail.update_attributes({:status => "active"})
    tempfile = Tempfile.new(File.basename(thumbnail.video.asset_file_name, File.extname(thumbnail.video.asset_file_name)) + ".jpg")
    command = "ffmpeg -i #{thumbnail.video.asset.path} -y -deinterlace -f image2 -ss #{thumbnail.time} #{tempfile.path}"
    logger.info(command)
    system command
    if tempfile.size > 0
      thumbnail.image = tempfile
      thumbnail.status = "complete"
      thumbnail.save
    else
      thumbnail.update_attributes({:status => "failed"})
      return false
    end
  end
end

