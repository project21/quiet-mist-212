# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110820153455) do

  create_table "authentications", :force => true do |t|
    t.integer "user_id",  :null => false
    t.string  "provider", :null => false
    t.string  "uid"
    t.string  "token"
    t.string  "secret"
  end

  create_table "book_ownerships", :force => true do |t|
    t.integer  "book_id",                                                                 :null => false
    t.integer  "user_id",                                                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "integer"
    t.integer  "reserver_id"
    t.string   "condition",                                           :default => "used", :null => false
    t.text     "condition_description"
    t.decimal  "offer",                 :precision => 5, :scale => 2, :default => 0.0
    t.datetime "offered_at"
    t.datetime "accepted_at"
    t.integer  "course_id"
    t.integer  "school_id",                                                               :null => false
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "edition"
    t.string   "isbn",       :null => false
  end

  add_index "books", ["isbn"], :name => "index_books_on_isbn", :unique => true

  create_table "campuses", :force => true do |t|
    t.string  "name"
    t.integer "postal_code"
    t.integer "location_id"
  end

  create_table "class_takens", :force => true do |t|
    t.string   "class_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id",  :null => false
  end

  create_table "majors", :force => true do |t|
    t.string   "name"
    t.boolean  "other",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",      :null => false
    t.integer  "course_id"
    t.string   "post_type"
    t.integer  "post_type_id"
    t.text     "content_data"
    t.integer  "reply_id"
  end

  create_table "professions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.text     "reply_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string  "name",        :null => false
    t.integer "postal_code"
    t.integer "location_id"
  end

  create_table "skills", :force => true do |t|
    t.string   "subject"
    t.string   "topic"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strengths", :force => true do |t|
    t.string   "subject"
    t.string   "topic"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_courses", :force => true do |t|
    t.integer "user_id",   :null => false
    t.integer "course_id", :null => false
    t.boolean "active",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "major"
    t.string   "sex"
    t.integer  "zipcode"
    t.string   "highschool"
    t.boolean  "registered"
    t.integer  "school_id"
    t.string   "image_url"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "weaknesses", :force => true do |t|
    t.string   "subject"
    t.string   "topic"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
