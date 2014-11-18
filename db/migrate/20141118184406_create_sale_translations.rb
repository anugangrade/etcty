class CreateSaleTranslations < ActiveRecord::Migration
  def change
    SaleType.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  # def down
  #   SaleType.drop_translation_table! migrate_data: true
  # end
end
