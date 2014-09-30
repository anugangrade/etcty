class CreateEducationConnects < ActiveRecord::Migration
  def change
    create_table :education_connects do |t|
      t.integer :education_id
      t.integer :education_type_id

      t.timestamps
    end
  end
end
