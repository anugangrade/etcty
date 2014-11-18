class CreateDealTranslations < ActiveRecord::Migration
  def change
    DealType.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  # def down
  #   DealType.drop_translation_table! migrate_data: true
  # end
end
