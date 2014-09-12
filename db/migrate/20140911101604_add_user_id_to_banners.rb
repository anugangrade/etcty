class AddUserIdToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :user_id, :integer
  end
end
