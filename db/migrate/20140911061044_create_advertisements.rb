class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :title
      t.text :description
      t.string :web_link
      t.integer :sub_category_id
      t.date :start_date
      t.date :end_date
      t.attachment :image

      t.timestamps
    end
  end
end
