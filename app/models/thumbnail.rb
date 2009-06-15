class Thumbnail < ActiveRecord::Base
  belongs_to :video
  
  acts_as_timecode :column => :time
  
  has_attached_file :image,
                    :storage => :database,
                    :styles => { :thumb => "75x75>", :small => "150x150>" }
  
  default_scope select_without_file_columns_for(:image)
  
  def before_save
    if self.time > self.video.duration
      return false
    end
    tempfile = Tempfile.new(File.basename(self.video.asset_file_name, File.extname(self.video.asset_file_name)) + ".jpg")
    command = "ffmpeg -i #{self.video.asset.path} -y -deinterlace -f image2 -ss #{self.time} #{tempfile.path}"
    logger.info(command)
    system command
    if tempfile.size > 0
      self.image = tempfile
    else
      return false
    end
  end
end
