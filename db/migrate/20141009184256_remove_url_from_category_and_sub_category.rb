class RemoveUrlFromCategoryAndSubCategory < ActiveRecord::Migration
  def change
  	remove_column :categories, :url, :string
  	remove_column :sub_categories, :url, :string
  end
end
