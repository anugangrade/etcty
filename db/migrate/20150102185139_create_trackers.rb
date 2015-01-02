class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.integer :visits, default: 0

      t.timestamps
    end
  end
end
