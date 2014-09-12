class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.integer :user_id
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
