class CreateCoupenBranches < ActiveRecord::Migration
  def change
    create_table :coupen_branches do |t|
      t.integer :coupen_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
