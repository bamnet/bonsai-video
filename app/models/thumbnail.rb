class Thumbnail < ActiveRecord::Base
  belongs_to :video
  
  acts_as_timecode :column => :time
  
  has_attached_file :image,
                    :storage => :database,
                    :styles => { :thumb => "75x75>", :small => "150x150>" }
  
  default_scope select_without_file_columns_for(:image)
  
end
