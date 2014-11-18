class CreateCategoryTranslations < ActiveRecord::Migration
  def change
    Category.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end
end
