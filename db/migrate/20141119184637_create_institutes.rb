class CreateInstitutes < ActiveRecord::Migration
  def change
    create_table :institutes do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.attachment :image

      t.timestamps
    end
  end
end
