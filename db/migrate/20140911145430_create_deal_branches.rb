class CreateDealBranches < ActiveRecord::Migration
  def change
    create_table :deal_branches do |t|
      t.integer :deal_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
