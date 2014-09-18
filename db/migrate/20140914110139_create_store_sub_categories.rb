class CreateStoreSubCategories < ActiveRecord::Migration
  def change
    create_table :store_sub_categories do |t|
      t.integer :store_id
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
