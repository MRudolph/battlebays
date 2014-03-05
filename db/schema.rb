# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100310190210) do

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",      :limit => 200,   :null => false
    t.text     "content",    :limit => 10000, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title",      :limit => 200,                  :null => false
    t.integer  "user_id"
    t.integer  "width",                     :default => 250, :null => false
    t.integer  "height",                    :default => 250, :null => false
    t.text     "rules"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "x",                                 :null => false
    t.integer  "y",                                 :null => false
    t.integer  "page_id",                           :null => false
    t.integer  "points",             :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "activated_at"
  end

  add_index "tiles", ["page_id", "x", "y"], :name => "index_tiles_on_page_id_and_x_and_y", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "points",             :default => 0,     :null => false
    t.boolean  "admin",              :default => false
    t.string   "shown"
  end

end
