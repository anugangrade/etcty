class CreateBannerBranches < ActiveRecord::Migration
  def change
    create_table :banner_branches do |t|
      t.integer :banner_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
