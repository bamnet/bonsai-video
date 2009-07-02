class AddStatusToThumbnails < ActiveRecord::Migration
  def self.up
    add_column :thumbnails, :status, :string
  end

  def self.down
    remove_column :thumbnails, :status
  end
end
