class CreateConversions < ActiveRecord::Migration
  def self.up
    create_table :conversions do |t|
      t.integer :video_id
      t.integer :profile_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :status
      t.text :log

      t.timestamps
    end
  end

  def self.down
    drop_table :conversions
  end
end
