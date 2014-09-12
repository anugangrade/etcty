class AddMoreFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :address, :text
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :users, :zip, :string
    add_column :users, :facebook_link, :string
    add_column :users, :twitter_link, :string
    add_column :users, :linkedin_link, :string
    add_attachment :users, :avatar


    add_index :users, :username, unique: true
  end
end
