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

ActiveRecord::Schema.define(:version => 20140916163146) do

  create_table "admins", :force => true do |t|
    t.string   "email",              :default => "", :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "data_migrations", :id => false, :force => true do |t|
    t.string "version", :null => false
  end

  add_index "data_migrations", ["version"], :name => "data_migrations_unique_data_migrations"

  create_table "embed_stats", :force => true do |t|
    t.string   "referrer"
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "embed_stats", ["referrer"], :name => "index_embed_stats_on_referrer", :unique => true

  create_table "members", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
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
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "membership_number"
    t.string   "product_name"
    t.boolean  "cached_active",          :default => false
    t.boolean  "cached_newsletter",      :default => false
    t.string   "stripe_customer_id"
    t.integer  "embed_stat_id"
    t.string   "organization_sector"
    t.string   "organization_size"
  end

  add_index "members", ["email"], :name => "members_index_members_on_email"
  add_index "members", ["reset_password_token"], :name => "members_index_members_on_reset_password_token"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "member_id"
    t.string   "logo"
    t.text     "description"
    t.string   "url"
    t.string   "cached_contact_name"
    t.string   "cached_contact_phone"
    t.string   "cached_contact_email"
    t.string   "cached_twitter"
    t.string   "cached_facebook"
    t.string   "cached_linkedin"
    t.string   "cached_tagline"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

end
