class CreateTutorialBranches < ActiveRecord::Migration
  def change
    create_table :tutorial_branches do |t|
      t.integer :branch_id
      t.integer :tutorial_id

      t.timestamps
    end
  end
end
