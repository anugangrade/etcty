class RemoveDescriptionAndAddTitleToBanners < ActiveRecord::Migration
  def change
  	remove_column :advertisements, :description
  	remove_column :deals, :description
  	add_column :banners, :title, :string
  end
end
