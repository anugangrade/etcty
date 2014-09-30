class AddIndexToTables < ActiveRecord::Migration
  def change
  	add_index :users, :name
    add_index :users, :city
    add_index :users, :state
    add_index :users, :country
    add_index :users, :zip
    add_index :users, :facebook_link
    add_index :users, :twitter_link
    add_index :users, :linkedin_link

  	add_index :categories, :name
  	add_index :categories, :url

  	add_index :sub_categories, :category_id
  	add_index :sub_categories, :name
  	add_index :sub_categories, :url

  	add_index :stores, :user_id
  	add_index :stores, :name

  	add_index :branches, :store_id
  	add_index :branches, :name
  	add_index :branches, :address
  	add_index :branches, :city
  	add_index :branches, :state
  	add_index :branches, :country
  	add_index :branches, :zip

  	add_index :zones, :name

  	add_index :advertisements, :title
  	add_index :advertisements, :web_link
  	add_index :advertisements, :start_date
  	add_index :advertisements, :end_date
  	add_index :advertisements, :user_id

  	add_index :adv_branches, :branch_id
  	add_index :adv_branches, :advertisement_id


  	add_index :adv_zones, :zone_id
  	add_index :adv_zones, :advertisement_id

  	add_index :deal_types, :name

  	add_index :deals, :title
  	add_index :deals, :web_link
  	add_index :deals, :user_id
  	add_index :deals, :start_date
  	add_index :deals, :end_date

  	add_index :deal_connects, :deal_id
  	add_index :deal_connects, :deal_type_id

  	add_index :banners, :web_link
  	add_index :banners, :user_id
  	add_index :banners, :title
  	add_index :banners, :start_date
  	add_index :banners, :end_date

  	add_index :deal_branches, :deal_id
  	add_index :deal_branches, :branch_id


  	add_index :banner_branches, :banner_id
  	add_index :banner_branches, :branch_id


  	add_index :store_sub_categories, :store_id
  	add_index :store_sub_categories, :sub_category_id

  end
end
