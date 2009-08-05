class AddViewCountToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :view_count, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :videos, :view_count
  end
end
