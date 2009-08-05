class Video < ActiveRecord::Base
  has_many :thumbnails,
             :class_name => '::Thumbnail',
             :order => :time,
             :dependent => :destroy,
             :counter_sql => 'SELECT COUNT(id) as count_id FROM thumbnails WHERE thumbnails.video_id = #{id}'
             
  has_many :conversions
  
  belongs_to :profile

  attr_accessor :import
  attr_accessor :no_thumbs
  
  acts_as_tree
  acts_as_timecode :column => :duration
  
  has_attached_file :asset, 
                    :url => "/bonsai/videos/dl/:id/:basename.:extension",
                    :path => ":rails_root/files/:attachment/:id/:style/:basename.:extension"
  
  def populate_meta_data(path = nil)
    path = self.asset.path unless path
    details = Mediainfo.new path
    self.format = details.format
    self.height = details.height
    self.width = details.width
    self.duration = details.duration / 1000 unless details.duration.nil?
    self.video_codec = details.video_format
    self.video_bitrate = details.video_bit_rate[/[0-9]*\.?\s?[0-9]+/].sub(/\s/, '') unless details.video_bit_rate.nil?
    self.video_resolution = details.video_resolution
    self.video_frame_rate = details.video_frame_rate[/[0-9]*\.?[0-9]+/] unless details.video_frame_rate.nil?
    self.audio_codec = details.audio_format
    self.audio_bitrate = details.audio_bit_rate[/[0-9]*\.?\s?[0-9]+/].sub(/\s/, '') unless details.audio_bit_rate.nil?
    self.audio_sample_rate = details.audio_sampling_rate[/[-+]?[0-9]*\.?[0-9]+/] unless details.audio_sampling_rate.nil?
    self.audio_resolution = details.audio_resolution 
  end
  
  def after_save
    if !self.no_thumbs && self.thumbnails.empty? && !self.duration.blank?
      [0, self.duration/2, self.duration-1].each do |time|
        self.thumbnails.create(:video_id => id, :time => time ,:status => "Requested")
      end
    end
  end
  
  def hw
    return "#{self.width}x#{self.height}"
  end
  
  def best(video_format = nil, video_codec = nil)
      conditions = Array.new
      conditions << '(id = :id OR parent_id = :id)'
      if(!video_codec.blank?)
        conditions << 'video_codec = :video_codec'
      end
      if(!video_format.blank?)
        conditions << 'format = :video_format'
      end
      return Video.find(:first, 
                      :conditions => [conditions.join(' AND '),
                                      { :id => self.id, :video_format => video_format, :video_codec => video_codec} ], 
                      :order => 'width DESC, height DESC, video_bitrate DESC, video_frame_rate DESC, audio_sample_rate DESC')
  end
  
  def aggregate_view_count
    return Video.sum(:view_count, :conditions => ['id = :id OR parent_id = :id', { :id => self.id}])
  end
end
