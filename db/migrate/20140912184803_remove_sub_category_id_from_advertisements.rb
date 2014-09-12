class RemoveSubCategoryIdFromAdvertisements < ActiveRecord::Migration
  def change
  	remove_column :advertisements, :sub_category_id, :integer
  end
end
