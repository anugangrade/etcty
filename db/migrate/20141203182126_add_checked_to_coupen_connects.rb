class AddCheckedToCoupenConnects < ActiveRecord::Migration
  def change
    add_column :coupen_connects, :checked, :boolean
  end
end
