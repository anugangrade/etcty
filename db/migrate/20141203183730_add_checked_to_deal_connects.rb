class AddCheckedToDealConnects < ActiveRecord::Migration
  def change
    add_column :deal_connects, :checked, :boolean
  end
end
