class AddBlockToUsers < ActiveRecord::Migration
  def change
    add_column :users, :block, :boolean, default: false
  end
end
