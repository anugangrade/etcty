class CreateEducationTranslations < ActiveRecord::Migration
  def change
    EducationType.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  # def down
  #   EducationType.drop_translation_table! migrate_data: true
  # end
end
