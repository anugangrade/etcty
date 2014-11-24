class AddPositionToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :position, :string
  end
end
