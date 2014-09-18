class RemoveSubCategoryIdFromStores < ActiveRecord::Migration
  def change
  	remove_column :stores, :sub_category_id, :integer
  end
end
