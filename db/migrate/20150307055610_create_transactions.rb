class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.integer  :user_id, null: false, index: true
    	t.string   :transaction_id
    	t.string   :capital_one_account_id
    	t.string   :raw_merchant
    	t.string   :merchant
    	t.boolean  :is_pending
    	t.date     :transaction_time
    	t.string   :categorization

      t.timestamps null: false
    end
  end
end
