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

ActiveRecord::Schema.define(:version => 20130123230158) do

  create_table "accounts", :force => true do |t|
    t.string   "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bets", :id => false, :force => true do |t|
    t.integer  "bet_id",      :null => false
    t.string   "match_name",  :null => false
    t.integer  "match_id",    :null => false
    t.string   "event_name",  :null => false
    t.string   "sport_name",  :null => false
    t.string   "type_of_bet"
    t.datetime "start_date"
    t.boolean  "is_opened"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "bets_users", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "bet_id",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "match"
    t.string   "prono"
    t.float    "cote"
    t.float    "mise"
    t.float    "gain"
  end

  create_table "file_parsing", :id => false, :force => true do |t|
    t.datetime "last_parse_date", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "odds", :id => false, :force => true do |t|
    t.integer  "odd_id",     :null => false
    t.integer  "bet_id",     :null => false
    t.string   "name",       :null => false
    t.string   "init_name",  :null => false
    t.float    "odd",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "username",               :default => "",   :null => false
    t.float    "credit",                 :default => 40.0, :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
