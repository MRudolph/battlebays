class AddActivatedAtUploadedAtToTiles < ActiveRecord::Migration
  def self.up
    add_column :tiles, :activated_at, :datetime
    remove_column :tiles, :activated
  end

  def self.down
    remove_column :tiles, :activated_at
    add_column :tiles, :activated,:boolean
  end
end
