class CreateFlyerBranches < ActiveRecord::Migration
  def change
    create_table :flyer_branches do |t|
      t.integer :flyer_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
