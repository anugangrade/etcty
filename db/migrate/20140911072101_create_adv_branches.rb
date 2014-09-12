class CreateAdvBranches < ActiveRecord::Migration
  def change
    create_table :adv_branches do |t|
      t.integer :branch_id
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
