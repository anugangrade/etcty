class CreateDealConnects < ActiveRecord::Migration
  def change
    create_table :deal_connects do |t|
      t.integer :deal_id
      t.integer :deal_type_id

      t.timestamps
    end
  end
end
