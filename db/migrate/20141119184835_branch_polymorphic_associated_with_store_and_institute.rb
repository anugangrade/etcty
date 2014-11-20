class BranchPolymorphicAssociatedWithStoreAndInstitute < ActiveRecord::Migration
  def change
  	rename_column :branches, :store_id, :branchable_id
    add_column :branches, :branchable_type, :string
  end
end
