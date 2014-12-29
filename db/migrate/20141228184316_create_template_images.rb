class CreateTemplateImages < ActiveRecord::Migration
  def change
    create_table :template_images do |t|
      t.integer :template_id
      t.string :order
      t.string :look_type

      t.timestamps
    end
  end
end
