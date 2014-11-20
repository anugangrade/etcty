class CreateInstituteSubCategories < ActiveRecord::Migration
  def change
    create_table :institute_sub_categories do |t|
      t.integer :institute_id
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
