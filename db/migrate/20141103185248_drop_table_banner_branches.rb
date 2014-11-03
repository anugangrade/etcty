class DropTableBannerBranches < ActiveRecord::Migration
  def change
  	drop_table :banner_branches
  end
end
