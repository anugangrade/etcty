class DropMultipleBranchTableConnects < ActiveRecord::Migration
  def change
  	drop_table :adv_branches 
  	drop_table :deal_branches  
  	drop_table :sale_branches 
  	drop_table :education_branches 
  	drop_table :flyer_branches 
  	drop_table :video_adv_branches
  	drop_table :coupen_branches 
  	drop_table :tutorial_branches 
  end
end
