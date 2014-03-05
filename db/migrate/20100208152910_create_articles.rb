class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :user_id
      t.string :title, :limit => 200,:null=>false
      t.text :content, :limit => 10_000,:null=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
