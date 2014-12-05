class CreateBranchConnects < ActiveRecord::Migration
  def change
    create_table :branch_connects do |t|
      t.integer :branch_id
      t.integer :connectable_id
      t.string :connectable_type
      t.boolean :checked

      t.timestamps
    end
  end
end
