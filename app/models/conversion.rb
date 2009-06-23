class Conversion < ActiveRecord::Base

  belongs_to :video
  belongs_to :profile
  
  def append_to_log(message)
    self.update_attribute(:log, "#{self.log}\n #{message} ")
  end
end
