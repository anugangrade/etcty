class CreateCoupenTranslations < ActiveRecord::Migration
  def change
    CoupenType.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  # def down
  #   CoupenType.drop_translation_table! migrate_data: true
  # end
end
