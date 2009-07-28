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
      if !black(:path => tempfile.path) || args[:allow_black]
        thumbnail.image = tempfile
        thumbnail.status = "complete"
        thumbnail.save
      else
        thumbnail.update_attributes({:status => "black"})
        thumbnail.destroy
        return false
      end
    else
      thumbnail.update_attributes({:status => "failed"})
      return false
    end
  end
  
  def black(args = nil)
    require 'RMagick'
    src_black = Magick::ImageList.new(RAILS_ROOT+'/public/images/black.jpg')
    source = Magick::ImageList.new(args[:path])
    black = src_black.scale(source.columns, source.rows)
    if source.difference(black)[1] < 0.01
      return true
    else
      return false
    end
  end
end

