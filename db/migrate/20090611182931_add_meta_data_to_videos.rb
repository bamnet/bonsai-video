class AddMetaDataToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :duration, :integer
    add_column :videos, :video_codec, :string
    add_column :videos, :video_bitrate, :decimal
    add_column :videos, :video_frame_rate, :decimal
    add_column :videos, :video_resolution, :integer
    add_column :videos, :audio_codec, :string
    add_column :videos, :audio_bitrate, :decimal
    add_column :videos, :audio_sample_rate, :integer
    add_column :videos, :audio_resolution, :integer
    
  end

  def self.down
    remove_column :videos, :duration
    remove_column :videos, :video_codec
    remove_column :videos, :video_bitrate
    remove_column :videos, :video_frame_rate
    remove_column :videos, :video_resolution
    remove_column :videos, :audio_codec
    remove_column :videos, :audio_bitrate
    remove_column :videos, :audio_sample_rate
    remove_column :videos, :audio_resolution
  end
end
