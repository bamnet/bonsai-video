class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :name
      t.integer :width
      t.integer :height
      t.string :format
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
