class CreateTemplateFonts < ActiveRecord::Migration
  def change
    create_table :template_fonts do |t|
      t.integer :template_id
      t.string :belongs_to
      t.string :position, default: "center"
      t.string :color, default: "#000"
      t.string :size, default: "small"
      t.string :family
      t.string :style, default: "normal"
      t.string :weight, default: "normal"
      t.string :text_decoration, default: "none"

      t.timestamps
    end
  end
end
