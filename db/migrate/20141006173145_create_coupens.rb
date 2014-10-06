class CreateCoupens < ActiveRecord::Migration
  def change
    create_table :coupens do |t|
      t.string :title
      t.string :web_link
      t.date :start_date
      t.date :end_date
      t.integer :user_id
      t.attachment :image

      t.timestamps
    end
  end
end
