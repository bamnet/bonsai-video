class AddProfileIdToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :profile_id, :integer
  end

  def self.down
    remove_column :videos, :profile_id
  end
end
