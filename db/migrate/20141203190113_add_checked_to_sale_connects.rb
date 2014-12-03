class AddCheckedToSaleConnects < ActiveRecord::Migration
  def change
    add_column :sale_connects, :checked, :boolean
  end
end
