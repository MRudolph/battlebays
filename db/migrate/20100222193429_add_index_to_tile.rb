class AddIndexToTile < ActiveRecord::Migration
  def self.up
     add_index(:tiles, [:page_id, :x,:y], :unique => true)

  end

  def self.down
      remove_index :tiles, :column => [:page_id, :x,:y]
  end
end
