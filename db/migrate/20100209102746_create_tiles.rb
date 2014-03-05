class CreateTiles < ActiveRecord::Migration
  def self.up
    create_table :tiles do |t|
      t.integer :user_id
      t.integer :x,:null=>false
      t.integer :y,:null=>false
      t.integer :page_id,:null=>false
      t.boolean :activated
      t.integer :points,:null=>false,:default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :tiles
  end
end
