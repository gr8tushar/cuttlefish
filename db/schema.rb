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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150123013225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["text"], name: "index_addresses_on_text", using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "invitation_created_at"
    t.integer  "team_id",                                null: false
    t.string   "name"
    t.boolean  "super_admin",            default: false, null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["invitation_token"], name: "index_admins_on_invitation_token", unique: true, using: :btree
  add_index "admins", ["invited_by_id"], name: "index_admins_on_invited_by_id", using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["team_id"], name: "index_admins_on_team_id", using: :btree

  create_table "apps", force: true do |t|
    t.string   "smtp_username"
    t.string   "name"
    t.string   "smtp_password"
    t.string   "custom_tracking_domain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "smtp_password_locked",      default: false, null: false
    t.boolean  "open_tracking_enabled",     default: true,  null: false
    t.boolean  "click_tracking_enabled",    default: true,  null: false
    t.text     "dkim_private_key"
    t.string   "from_domain"
    t.boolean  "dkim_enabled",              default: false, null: false
    t.integer  "archived_deliveries_count", default: 0,     null: false
    t.integer  "team_id"
    t.boolean  "cuttlefish",                default: false, null: false
  end

  add_index "apps", ["team_id"], name: "index_apps_on_team_id", using: :btree

  create_table "black_lists", force: true do |t|
    t.integer  "address_id"
    t.integer  "caused_by_delivery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id",               null: false
  end

  add_index "black_lists", ["team_id"], name: "index_black_lists_on_team_id", using: :btree

  create_table "click_events", force: true do |t|
    t.integer  "delivery_link_id"
    t.text     "user_agent"
    t.text     "referer"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "click_events", ["delivery_link_id"], name: "index_click_events_on_delivery_link_id", using: :btree

  create_table "deliveries", force: true do |t|
    t.integer  "email_id"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sent",              default: false, null: false
    t.string   "postfix_queue_id"
    t.boolean  "open_tracked",      default: false, null: false
    t.integer  "open_events_count", default: 0,     null: false
    t.string   "status",                            null: false
    t.integer  "app_id"
  end

  add_index "deliveries", ["address_id", "created_at"], name: "index_deliveries_on_address_id_and_created_at", using: :btree
  add_index "deliveries", ["app_id"], name: "index_deliveries_on_app_id", using: :btree
  add_index "deliveries", ["created_at", "open_events_count"], name: "index_deliveries_on_created_at_and_open_events_count", using: :btree
  add_index "deliveries", ["email_id", "address_id"], name: "index_deliveries_on_email_id_and_address_id", using: :btree
  add_index "deliveries", ["open_tracked", "created_at"], name: "index_deliveries_on_open_tracked_and_created_at", using: :btree
  add_index "deliveries", ["postfix_queue_id"], name: "index_deliveries_on_postfix_queue_id", using: :btree

  create_table "delivery_links", force: true do |t|
    t.integer  "delivery_id",                    null: false
    t.integer  "link_id",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "click_events_count", default: 0, null: false
  end

  add_index "delivery_links", ["delivery_id"], name: "index_delivery_links_on_delivery_id", using: :btree
  add_index "delivery_links", ["link_id"], name: "index_delivery_links_on_link_id", using: :btree

  create_table "emails", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_address_id"
    t.string   "message_id"
    t.string   "data_hash"
    t.integer  "app_id",          null: false
    t.string   "subject"
  end

  add_index "emails", ["app_id"], name: "index_emails_on_app_id", using: :btree
  add_index "emails", ["created_at"], name: "index_emails_on_created_at", using: :btree
  add_index "emails", ["from_address_id"], name: "index_emails_on_from_address_id", using: :btree
  add_index "emails", ["message_id"], name: "index_emails_on_message_id", using: :btree

  create_table "links", force: true do |t|
    t.string   "url",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["url"], name: "index_links_on_url", using: :btree

  create_table "open_events", force: true do |t|
    t.integer  "delivery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "user_agent"
    t.text     "referer"
    t.string   "ip"
    t.string   "ua_family"
    t.string   "ua_version"
    t.string   "os_family"
    t.string   "os_version"
  end

  add_index "open_events", ["delivery_id"], name: "index_open_events_on_delivery_id", using: :btree

  create_table "postfix_log_lines", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "time",            null: false
    t.string   "relay",           null: false
    t.string   "delay",           null: false
    t.string   "delays",          null: false
    t.string   "dsn",             null: false
    t.text     "extended_status", null: false
    t.integer  "delivery_id",     null: false
  end

  add_index "postfix_log_lines", ["delivery_id"], name: "index_postfix_log_lines_on_delivery_id", using: :btree
  add_index "postfix_log_lines", ["time", "delivery_id"], name: "index_postfix_log_lines_on_time_and_delivery_id", using: :btree

  create_table "teams", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "emails", "addresses", name: "emails_from_address_id_fk", column: "from_address_id"
  add_foreign_key "emails", "apps", name: "emails_app_id_fk", dependent: :delete

  add_foreign_key "postfix_log_lines", "deliveries", name: "postfix_log_lines_delivery_id_fk", dependent: :delete

end
