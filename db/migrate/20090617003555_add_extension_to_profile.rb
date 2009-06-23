class AddExtensionToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :extension, :string
  end

  def self.down
    remove_column :profiles, :extension
  end
end
