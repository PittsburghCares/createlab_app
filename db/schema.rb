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

ActiveRecord::Schema.define(:version => 20130116212222) do

  create_table "events", :force => true do |t|
    t.text     "name"
    t.integer  "page_id"
    t.text     "lab_contact"
    t.text     "partner_contact"
    t.integer  "pre_school",        :default => 0
    t.integer  "elementary_school", :default => 0
    t.integer  "middle_school",     :default => 0
    t.integer  "high_school",       :default => 0
    t.integer  "adult",             :default => 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "comments"
    t.boolean  "is_published",      :default => false
    t.boolean  "is_deleted",        :default => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mentors",           :default => 0
  end

  add_index "events", ["page_id"], :name => "index_events_on_page_id"

  create_table "funders", :force => true do |t|
    t.text     "fullname"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_images", :force => true do |t|
    t.integer  "page_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_images", ["page_id"], :name => "index_page_images_on_page_id"

  create_table "page_web_links", :force => true do |t|
    t.integer  "page_id"
    t.text     "label"
    t.text     "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_web_links", ["page_id"], :name => "index_page_web_links_on_page_id"

  create_table "pages", :force => true do |t|
    t.text     "name"
    t.integer  "project_id"
    t.text     "description"
    t.boolean  "has_student_dialogues",              :default => false
    t.boolean  "is_published",                       :default => false
    t.boolean  "is_deleted",                         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_outreach",                       :default => true
    t.text     "status"
    t.integer  "list_position",         :limit => 2
    t.boolean  "is_placeholder",                     :default => false
  end

  add_index "pages", ["project_id"], :name => "index_pages_on_project_id"

  create_table "pages_funders", :id => false, :force => true do |t|
    t.integer "page_id"
    t.integer "funder_id"
  end

  add_index "pages_funders", ["page_id", "funder_id"], :name => "index_pages_funders_on_page_id_and_funder_id"

  create_table "project_images", :force => true do |t|
    t.integer  "project_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_images", ["project_id"], :name => "index_project_images_on_project_id"

  create_table "project_web_links", :force => true do |t|
    t.integer  "project_id"
    t.text     "label"
    t.text     "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_web_links", ["project_id"], :name => "index_project_web_links_on_project_id"

  create_table "projects", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.boolean  "has_outreach", :default => true
    t.text     "status"
    t.boolean  "is_published", :default => false
    t.boolean  "is_deleted",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "email"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name", :default => ""
  end

  create_table "themes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "login",                     :limit => 40
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "password_reset_code",       :limit => 40
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.boolean  "is_deleted",                              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "users_events", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_events", ["user_id", "event_id"], :name => "index_users_events_on_user_id_and_event_id"

  create_table "users_projects", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  add_index "users_projects", ["user_id", "project_id"], :name => "index_users_projects_on_user_id_and_project_id"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
