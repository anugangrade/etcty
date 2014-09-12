class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :store_id
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip

      t.timestamps
    end
  end
end
