class CreateVideoAdvBranches < ActiveRecord::Migration
  def change
    create_table :video_adv_branches do |t|
      t.integer :video_adv_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
