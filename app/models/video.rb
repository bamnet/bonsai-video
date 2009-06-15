class Video < ActiveRecord::Base
  has_many :thumbnails,
             :class_name => '::Thumbnail',
             :order => :time,
             :dependent => :destroy,
             :counter_sql => 'SELECT COUNT(id) as count_id FROM thumbnails WHERE thumbnails.video_id = #{id}'

  attr_accessor :import
  
  acts_as_tree
  acts_as_timecode :column => :duration
  
  has_attached_file :asset
  
  def populate_meta_data(path = nil)
    path = self.asset.path unless path
    details = Mediainfo.new path
    self.format = details.format
    self.height = details.height
    self.width = details.width
    self.duration = details.duration / 1000
    self.video_codec = details.video_format
    self.video_bitrate = details.video_bit_rate[/[0-9]*\.?\s?[0-9]+/].sub(/\s/, '')
    self.video_resolution = details.video_resolution
    self.video_frame_rate = details.video_frame_rate[/[0-9]*\.?[0-9]+/]
    self.audio_codec = details.audio_format
    self.audio_bitrate = details.audio_bit_rate[/[0-9]*\.?\s?[0-9]+/].sub(/\s/, '') unless details.audio_bit_rate.nil?
    self.audio_sample_rate = details.audio_sampling_rate[/[-+]?[0-9]*\.?[0-9]+/] unless details.audio_sampling_rate.nil?
    self.audio_resolution = details.audio_resolution 
  end
  
  def after_save
    if self.thumbnails.empty?
      [0, self.duration/2, self.duration-1].each do |time|
        self.thumbnails.create(:video_id => id, :time => time)
      end
    end
  end
end
