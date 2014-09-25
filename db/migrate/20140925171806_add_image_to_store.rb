class AddImageToStore < ActiveRecord::Migration
  def change
    add_attachment :stores, :image
  end
end
