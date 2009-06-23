class Profile < ActiveRecord::Base
  has_many :videos
  has_many :conversions
end
