class CreateSaleBranches < ActiveRecord::Migration
  def change
    create_table :sale_branches do |t|
      t.integer :sale_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
