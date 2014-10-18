class AddAmountToTypes < ActiveRecord::Migration
  def change
  	add_column :zones, :amount, :integer
  	add_column :deal_types, :amount, :integer
  	add_column :education_types, :amount, :integer
  	add_column :sale_types, :amount, :integer
  end
end
