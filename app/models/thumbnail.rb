class Thumbnail < ActiveRecord::Base
  belongs_to :video
  
  acts_as_timecode :column => :time
  
  has_attached_file :image,
                    :storage => :database,
                    :styles => { :thumb => "75x75>", :small => "150x150>" }
  
  default_scope select_without_file_columns_for(:image)
  
  def guess_size(style = '')
    if(style == 'thumb' || style == 'small')
      if(style == 'thumb')
        max = 75
      elsif(style == 'small')
        max = 150
      else
        max = 0
      end
      #Compute how big the thumbnail should be
      if self.video.width >= self.video.height
        width = max
        height = (self.video.height.to_f / self.video.width.to_f * width).to_i
      else 
        height = max
        width = (self.video.width.to_f / self.video.height.to_f * height).to_i
      end
      return {:width => width, :height => height}
    else
      return {:width => self.video.width, :height => self.video.height}
    end
  end
end
