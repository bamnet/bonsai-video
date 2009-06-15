class AddAttachmentsImageToThumbnail < ActiveRecord::Migration
  def self.up
    add_column :thumbnails, :image_file_name, :string
    add_column :thumbnails, :image_content_type, :string
    add_column :thumbnails, :image_file_size, :integer
    add_column :thumbnails, :image_updated_at, :datetime
    execute 'ALTER TABLE thumbnails ADD COLUMN image_file LONGBLOB'
    execute 'ALTER TABLE thumbnails ADD COLUMN image_small_file LONGBLOB'
    execute 'ALTER TABLE thumbnails ADD COLUMN image_thumb_file LONGBLOB'
  end

  def self.down
    remove_column :thumbnails, :image_file_name
    remove_column :thumbnails, :image_content_type
    remove_column :thumbnails, :image_file_size
    remove_column :thumbnails, :image_updated_at
    remove_column :thumbnails, :image_file
    remove_column :thumbnails, :image_small_file
    remove_column :thumbnails, :image_thumb_file
  end
end
