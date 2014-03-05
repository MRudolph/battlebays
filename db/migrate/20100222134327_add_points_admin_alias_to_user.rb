class AddPointsAdminAliasToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :points, :integer,:default=>0,:null=>false
    add_column :users, :admin, :boolean,:default=>false
    add_column :users, :shown, :string
  end

  def self.down
    remove_column :users, :shown
    remove_column :users, :admin
    remove_column :users, :points
  end
end
