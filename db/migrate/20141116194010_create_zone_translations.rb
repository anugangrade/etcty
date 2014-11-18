class CreateZoneTranslations < ActiveRecord::Migration
  def change
    Zone.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  # def down
  #   Zone.drop_translation_table! migrate_data: true
  # end

end
