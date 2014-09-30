class CreateEducationBranches < ActiveRecord::Migration
  def change
    create_table :education_branches do |t|
      t.integer :education_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
