class CreateThumbnails < ActiveRecord::Migration
  def self.up
    create_table :thumbnails do |t|
      t.integer :video_id
      t.integer :timecode

      t.timestamps
    end
  end

  def self.down
    drop_table :thumbnails
  end
end
