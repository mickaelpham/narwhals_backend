class ChangeTransactionColumnName < ActiveRecord::Migration
  def change
    rename_column :savings, :transaction_id, :co_transaction_id
  end
end
