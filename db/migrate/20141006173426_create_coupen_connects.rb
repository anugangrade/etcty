class CreateCoupenConnects < ActiveRecord::Migration
  def change
    create_table :coupen_connects do |t|
      t.integer :coupen_id
      t.integer :coupen_type_id

      t.timestamps
    end
  end
end
