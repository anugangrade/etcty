class AddCheckedToEducationConnects < ActiveRecord::Migration
  def change
    add_column :education_connects, :checked, :boolean
  end
end
