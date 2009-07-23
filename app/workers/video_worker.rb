class VideoWorker < Workling::Base
  #Run the conversion of the video
  def convert(args = nil)
    #Open all the objects we'll need
    logger.info("Calling convert method for conversion #{args[:conversion_id]}.")
    conversion = Conversion.find(args[:conversion_id])
    video = conversion.video
    profile = conversion.profile
    conversion.append_to_log "Starting conversion work on #{video.id}: #{video.name} - #{video.asset.path}"
    logger.info("Starting conversion work on #{video.id}: #{video.name} - #{video.asset.path}")
    conversion.update_attributes({:status => "active", :start_time => Time.now})
    
    #Create the temporary file, and prepare the command
    tempfile = Tempfile.new([File.basename(video.asset_file_name, File.extname(video.asset_file_name)), ".#{profile.extension}"])
    command = profile.command
    command.sub!(':outfile', tempfile.path)
    command.sub!(':infile', video.asset.path)
    command.sub!(':width', video.width.to_s) unless video.width.blank?
    command.sub!(':height', video.height.to_s)  unless video.height.blank?
    conversion.append_to_log command
    logger.info(command)
    conversion.append_to_log "Closing tempfile accessor"
    logger.info("Closing tempfile accessor")
    tempfile.close
    
    #Run the command
    conversion.append_to_log "Starting command"
    logger.info("Exec'ing command")
    system command
    
    #Start to save the final output
    conversion.append_to_log "Command complete"
    logger.info("Exec complete!  Opening tempfile up again")
    conversion.update_attributes({:status => "saving"})
    tempfile.open
    
    #Verify the file isn't empty, indicating a conversion error
    if tempfile.size <= 0
      conversion.append_to_log "Expected output file is empty.  Cancelling."
      logger.info("Expected output file is empty.  Cancelling.")
      conversion.update_attributes({:status => "failed", :end_time => Time.now})
    else
      #Build the new video object, mark it for no auto-thumbnail generation
      conversion.append_to_log "Starting save"
      logger.info("Starting save")
      new_v = Video.new(:name => video.name, :parent_id => video.id, :profile_id => profile.id, :no_thumbs => true)
      
      #Populate the metadata just like any other video
      conversion.append_to_log "Populating metadata for new video"
      logger.info("Populating Metadata")
      new_v.populate_meta_data tempfile.path
      
      #Set the new videos's file to the temporary file
      new_v.asset = tempfile
      conversion.append_to_log "Trying the save"
      #Start the save, which can generate thumbnails (and take a long time) if the no_thumbs flag isn't set
      if new_v.save
        conversion.append_to_log "Conversion of #{video.id}: #{video.name} - #{video.asset.path} to #{new_v.id} complete."
        logger.info("Conversion of #{video.id}: #{video.name} - #{video.asset.path} to #{new_v.id} complete.")
        conversion.update_attributes({:status => "complete", :end_time => Time.now})
      else
        conversion.append_to_log "Conversion of #{video.id}: #{video.name} - #{video.asset.path} FAILED."
        logger.info("Conversion of #{video.id}: #{video.name} - #{video.asset.path} FAILED.")
        conversion.update_attributes({:status => "failed", :end_time => Time.now})
      end
    end
  end
  

end

