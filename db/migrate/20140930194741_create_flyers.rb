class CreateFlyers < ActiveRecord::Migration
  def change
    create_table :flyers do |t|
      t.string :title
      t.string :web_link
      t.date :start_date
      t.date :end_date
      t.attachment :image
      t.integer :user_id

      t.timestamps
    end
  end
end
