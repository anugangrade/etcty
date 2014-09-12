class CreateAdvZones < ActiveRecord::Migration
  def change
    create_table :adv_zones do |t|
      t.integer :zone_id
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
