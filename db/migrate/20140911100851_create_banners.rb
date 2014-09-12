class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :web_link
      t.attachment :image

      t.timestamps
    end
  end
end
