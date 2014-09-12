class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title
      t.text :description
      t.string :web_link
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.attachment :image

      t.timestamps
    end
  end
end
