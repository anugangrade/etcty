class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :purchasable_id
      t.string :purchasable_type
      t.integer :amount
      t.string :currency
      t.string :paypal_token
      t.string :paypal_payer_id
      t.string :status

      t.timestamps
    end
  end
end
