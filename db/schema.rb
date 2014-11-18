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

ActiveRecord::Schema.define(version: 20141118184412) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "adv_branches", force: true do |t|
    t.integer  "branch_id"
    t.integer  "advertisement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adv_branches", ["advertisement_id"], name: "index_adv_branches_on_advertisement_id", using: :btree
  add_index "adv_branches", ["branch_id"], name: "index_adv_branches_on_branch_id", using: :btree

  create_table "adv_zones", force: true do |t|
    t.integer  "zone_id"
    t.integer  "advertisement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adv_zones", ["advertisement_id"], name: "index_adv_zones_on_advertisement_id", using: :btree
  add_index "adv_zones", ["zone_id"], name: "index_adv_zones_on_zone_id", using: :btree

  create_table "advertisements", force: true do |t|
    t.string   "title"
    t.string   "web_link"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "advertisements", ["end_date"], name: "index_advertisements_on_end_date", using: :btree
  add_index "advertisements", ["start_date"], name: "index_advertisements_on_start_date", using: :btree
  add_index "advertisements", ["title"], name: "index_advertisements_on_title", using: :btree
  add_index "advertisements", ["user_id"], name: "index_advertisements_on_user_id", using: :btree
  add_index "advertisements", ["web_link"], name: "index_advertisements_on_web_link", using: :btree

  create_table "banners", force: true do |t|
    t.string   "web_link"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "banners", ["end_date"], name: "index_banners_on_end_date", using: :btree
  add_index "banners", ["start_date"], name: "index_banners_on_start_date", using: :btree
  add_index "banners", ["title"], name: "index_banners_on_title", using: :btree
  add_index "banners", ["user_id"], name: "index_banners_on_user_id", using: :btree
  add_index "banners", ["web_link"], name: "index_banners_on_web_link", using: :btree

  create_table "branches", force: true do |t|
    t.integer  "store_id"
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["address"], name: "index_branches_on_address", using: :btree
  add_index "branches", ["city"], name: "index_branches_on_city", using: :btree
  add_index "branches", ["country"], name: "index_branches_on_country", using: :btree
  add_index "branches", ["name"], name: "index_branches_on_name", using: :btree
  add_index "branches", ["state"], name: "index_branches_on_state", using: :btree
  add_index "branches", ["store_id"], name: "index_branches_on_store_id", using: :btree
  add_index "branches", ["zip"], name: "index_branches_on_zip", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "coupen_branches", force: true do |t|
    t.integer  "coupen_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupen_connects", force: true do |t|
    t.integer  "coupen_id"
    t.integer  "coupen_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupen_type_translations", force: true do |t|
    t.integer  "coupen_type_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "coupen_type_translations", ["coupen_type_id"], name: "index_coupen_type_translations_on_coupen_type_id", using: :btree
  add_index "coupen_type_translations", ["locale"], name: "index_coupen_type_translations_on_locale", using: :btree

  create_table "coupen_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupens", force: true do |t|
    t.string   "title"
    t.string   "web_link"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deal_branches", force: true do |t|
    t.integer  "deal_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_branches", ["branch_id"], name: "index_deal_branches_on_branch_id", using: :btree
  add_index "deal_branches", ["deal_id"], name: "index_deal_branches_on_deal_id", using: :btree

  create_table "deal_connects", force: true do |t|
    t.integer  "deal_id"
    t.integer  "deal_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_connects", ["deal_id"], name: "index_deal_connects_on_deal_id", using: :btree
  add_index "deal_connects", ["deal_type_id"], name: "index_deal_connects_on_deal_type_id", using: :btree

  create_table "deal_type_translations", force: true do |t|
    t.integer  "deal_type_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "deal_type_translations", ["deal_type_id"], name: "index_deal_type_translations_on_deal_type_id", using: :btree
  add_index "deal_type_translations", ["locale"], name: "index_deal_type_translations_on_locale", using: :btree

  create_table "deal_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
  end

  add_index "deal_types", ["name"], name: "index_deal_types_on_name", using: :btree

  create_table "deals", force: true do |t|
    t.string   "title"
    t.string   "web_link"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deals", ["end_date"], name: "index_deals_on_end_date", using: :btree
  add_index "deals", ["start_date"], name: "index_deals_on_start_date", using: :btree
  add_index "deals", ["title"], name: "index_deals_on_title", using: :btree
  add_index "deals", ["user_id"], name: "index_deals_on_user_id", using: :btree
  add_index "deals", ["web_link"], name: "index_deals_on_web_link", using: :btree

  create_table "education_branches", force: true do |t|
    t.integer  "education_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_connects", force: true do |t|
    t.integer  "education_id"
    t.integer  "education_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_type_translations", force: true do |t|
    t.integer  "education_type_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "education_type_translations", ["education_type_id"], name: "index_education_type_translations_on_education_type_id", using: :btree
  add_index "education_type_translations", ["locale"], name: "index_education_type_translations_on_locale", using: :btree

  create_table "education_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
  end

  create_table "educations", force: true do |t|
    t.string   "title"
    t.string   "web_link"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flyer_branches", force: true do |t|
    t.integer  "flyer_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flyers", force: true do |t|
    t.string   "title"
    t.string   "web_link"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_branches", force: true do |t|
    t.integer  "sale_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_connects", force: true do |t|
    t.integer  "sale_id"
    t.integer  "sale_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_type_translations", force: true do |t|
    t.integer  "sale_type_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "sale_type_translations", ["locale"], name: "index_sale_type_translations_on_locale", using: :btree
  add_index "sale_type_translations", ["sale_type_id"], name: "index_sale_type_translations_on_sale_type_id", using: :btree

  create_table "sale_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
  end

  add_index "sale_types", ["name"], name: "index_sale_types_on_name", using: :btree

  create_table "sales", force: true do |t|
    t.string   "title"
    t.string   "web_link"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales", ["end_date"], name: "index_sales_on_end_date", using: :btree
  add_index "sales", ["start_date"], name: "index_sales_on_start_date", using: :btree
  add_index "sales", ["title"], name: "index_sales_on_title", using: :btree
  add_index "sales", ["user_id"], name: "index_sales_on_user_id", using: :btree
  add_index "sales", ["web_link"], name: "index_sales_on_web_link", using: :btree

  create_table "store_sub_categories", force: true do |t|
    t.integer  "store_id"
    t.integer  "sub_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_sub_categories", ["store_id"], name: "index_store_sub_categories_on_store_id", using: :btree
  add_index "store_sub_categories", ["sub_category_id"], name: "index_store_sub_categories_on_sub_category_id", using: :btree

  create_table "stores", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
  end

  add_index "stores", ["name"], name: "index_stores_on_name", using: :btree
  add_index "stores", ["user_id"], name: "index_stores_on_user_id", using: :btree

  create_table "sub_categories", force: true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_categories", ["category_id"], name: "index_sub_categories_on_category_id", using: :btree
  add_index "sub_categories", ["name"], name: "index_sub_categories_on_name", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
    t.integer  "amount"
    t.string   "currency"
    t.string   "paypal_token"
    t.string   "paypal_payer_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "username"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "linkedin_link"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_admin",               default: false
    t.boolean  "block",                  default: false
  end

  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["country"], name: "index_users_on_country", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_link"], name: "index_users_on_facebook_link", using: :btree
  add_index "users", ["linkedin_link"], name: "index_users_on_linkedin_link", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree
  add_index "users", ["twitter_link"], name: "index_users_on_twitter_link", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree
  add_index "users", ["zip"], name: "index_users_on_zip", using: :btree

  create_table "video_adv_branches", force: true do |t|
    t.integer  "video_adv_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "video_advs", force: true do |t|
    t.string   "title"
    t.string   "youtube_url"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zone_translations", force: true do |t|
    t.integer  "zone_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "zone_translations", ["locale"], name: "index_zone_translations_on_locale", using: :btree
  add_index "zone_translations", ["zone_id"], name: "index_zone_translations_on_zone_id", using: :btree

  create_table "zones", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
  end

  add_index "zones", ["name"], name: "index_zones_on_name", using: :btree

end
