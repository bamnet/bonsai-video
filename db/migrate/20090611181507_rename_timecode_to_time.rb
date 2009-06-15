class RenameTimecodeToTime < ActiveRecord::Migration
  def self.up
    rename_column :thumbnails, :timecode, :time 
  end

  def self.down
    rename_column :thumbnails, :timecode, :time
  end
end
