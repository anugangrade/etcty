class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :belongs_to
      t.string :logo_position, default: "center"
      t.string :logo_image_type
      t.string :bg_color, default: "#FFF"
      t.boolean :bg_image, default: 0
      t.integer :no_of_images, default: 0

      t.timestamps
    end
  end
end
