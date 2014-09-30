class CreateSaleTypes < ActiveRecord::Migration
  def change
    create_table :sale_types do |t|
      t.string :name

      t.timestamps
    end

    add_index :sale_types, :name

  end
end
