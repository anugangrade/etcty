class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :title
      t.string :web_link
      t.date :start_date
      t.date :end_date
      t.attachment :image
      t.integer :user_id

      t.timestamps
    end

    add_index :sales, :title
    add_index :sales, :web_link
    add_index :sales, :start_date
    add_index :sales, :end_date
    add_index :sales, :user_id

  end
end
