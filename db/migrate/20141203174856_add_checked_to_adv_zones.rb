class AddCheckedToAdvZones < ActiveRecord::Migration
  def change
    add_column :adv_zones, :checked, :boolean
  end
end
