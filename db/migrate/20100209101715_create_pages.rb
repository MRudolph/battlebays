class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title,:null=>false,:limit=>200
      t.integer :user_id
      t.integer :width,:null=>false,:default=>250
      t.integer :height,:null=>false,:default=>250
      t.text :rules
      t.timestamps
     
    end
  end

  def self.down
    drop_table :pages
  end
end
