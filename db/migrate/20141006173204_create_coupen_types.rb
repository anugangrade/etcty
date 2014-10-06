class CreateCoupenTypes < ActiveRecord::Migration
  def change
    create_table :coupen_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
