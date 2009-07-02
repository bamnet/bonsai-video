class ThumbnailWorker < BackgrounDRb::MetaWorker
  set_worker_name :thumbnail_worker
  pool_size 2
  def create(args = nil)
    logger.info("Creating thumbnail worker")
  end
  #Queue the request for a thumbnail
  def queue_thumbnail(args)
    thumbnail = Thumbnail.find(args[:thumbnail_id])
    thumbnail.update_attributes({:status => "queued"})
    thread_pool.defer(:generate,args)
  end
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
    persistent_job.finish!
  end
end

