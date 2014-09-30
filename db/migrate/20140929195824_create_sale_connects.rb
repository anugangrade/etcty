class CreateSaleConnects < ActiveRecord::Migration
  def change
    create_table :sale_connects do |t|
      t.integer :sale_id
      t.integer :sale_type_id

      t.timestamps
    end
  end
end
