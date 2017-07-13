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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170711215520) do

  create_table "admins", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "data_migrations", id: false, force: :cascade do |t|
    t.string "version", limit: 255, null: false
    t.index ["version"], name: "data_migrations_unique_data_migrations"
  end

  create_table "embed_stats", force: :cascade do |t|
    t.string "referrer", limit: 255
    t.integer "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referrer"], name: "index_embed_stats_on_referrer", unique: true
  end

  create_table "listings", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "member_id"
    t.string "logo", limit: 255
    t.text "description"
    t.string "url", limit: 255
    t.string "contact_name", limit: 255
    t.string "contact_phone", limit: 255
    t.string "contact_email", limit: 255
    t.string "twitter", limit: 255
    t.string "facebook", limit: 255
    t.string "linkedin", limit: 255
    t.string "tagline", limit: 255
  end

  create_table "members", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "membership_number", limit: 8
    t.string "product_name", limit: 255
    t.boolean "active", default: false
    t.boolean "newsletter", default: false
    t.integer "embed_stat_id"
    t.string "organization_sector", limit: 255
    t.string "organization_size", limit: 255
    t.string "name", limit: 255
    t.string "phone", limit: 255
    t.text "address"
    t.string "street_address", limit: 255
    t.string "address_locality", limit: 255
    t.string "address_region", limit: 255
    t.string "address_country", limit: 255
    t.string "postal_code", limit: 255
    t.string "organization_type", limit: 255
    t.string "organization_company_number", limit: 255
    t.boolean "current", default: false, null: false
    t.string "origin", limit: 255, default: "odihq", null: false
    t.boolean "share_with_third_parties", default: false
    t.string "twitter", limit: 255
    t.string "organization_name", limit: 255
    t.string "organization_logo", limit: 255
    t.text "organization_description"
    t.string "organization_url", limit: 255
    t.string "organization_contact_name", limit: 255
    t.string "organization_contact_phone", limit: 255
    t.string "organization_contact_email", limit: 255
    t.string "organization_twitter", limit: 255
    t.string "organization_facebook", limit: 255
    t.string "organization_linkedin", limit: 255
    t.string "organization_tagline", limit: 255
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text "message"
    t.string "username", limit: 255
    t.integer "item"
    t.string "table", limit: 255
    t.integer "month", limit: 2
    t.integer "year", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories"
  end

end
