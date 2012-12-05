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

ActiveRecord::Schema.define(:version => 20121205190322) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "link_rates", :force => true do |t|
    t.integer  "link_id"
    t.integer  "this_week",     :default => 0
    t.integer  "prev_week",     :default => 0
    t.integer  "this_month",    :default => 0
    t.integer  "prev_month",    :default => 0
    t.integer  "position",      :default => 0
    t.integer  "prev_position", :default => 0
    t.integer  "total",         :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "links", :force => true do |t|
    t.text     "name"
    t.integer  "domain_id"
    t.text     "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locked_emails", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.string   "tool"
    t.float    "amount"
    t.integer  "ip"
    t.string   "payer_id"
    t.boolean  "is_completed", :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.float    "price"
    t.integer  "sites_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "promos", :force => true do |t|
    t.string   "name"
    t.integer  "period"
    t.date     "active_upto"
    t.boolean  "registration", :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "site_rates", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "this_week",     :default => 0
    t.integer  "prev_week",     :default => 0
    t.integer  "this_month",    :default => 0
    t.integer  "prev_month",    :default => 0
    t.integer  "position",      :default => 0
    t.integer  "prev_position", :default => 0
    t.integer  "total",         :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "tweets", :force => true do |t|
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "unlock_requests", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.string   "status",     :default => "new"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "user_links", :force => true do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.string   "title"
    t.text     "description"
    t.string   "email"
    t.boolean  "is_private",  :default => false
    t.boolean  "is_spam",     :default => false
    t.boolean  "is_send",     :default => false
    t.string   "link_hash"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "user_plans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.date     "paid_upto"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_promos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "promo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_watches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role",                   :default => "user"
    t.boolean  "is_locked",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  add_foreign_key "link_rates", "links", :name => "link_rates_link_id_fk", :dependent => :delete

  add_foreign_key "links", "domains", :name => "links_domain_id_fk", :dependent => :delete

  add_foreign_key "payments", "users", :name => "payments_user_id_fk", :dependent => :delete

  add_foreign_key "site_rates", "domains", :name => "site_rates_domain_id_fk", :dependent => :delete

  add_foreign_key "unlock_requests", "users", :name => "unlock_requests_user_id_fk", :dependent => :delete

  add_foreign_key "user_links", "links", :name => "user_links_link_id_fk", :dependent => :delete
  add_foreign_key "user_links", "users", :name => "user_links_user_id_fk", :dependent => :delete

  add_foreign_key "user_plans", "plans", :name => "user_plans_plan_id_fk", :dependent => :delete
  add_foreign_key "user_plans", "users", :name => "user_plans_user_id_fk", :dependent => :delete

  add_foreign_key "user_promos", "promos", :name => "user_promos_promo_id_fk", :dependent => :delete
  add_foreign_key "user_promos", "users", :name => "user_promos_user_id_fk", :dependent => :delete

  add_foreign_key "user_watches", "domains", :name => "user_watches_domain_id_fk", :dependent => :delete
  add_foreign_key "user_watches", "users", :name => "user_watches_user_id_fk", :dependent => :delete

end
