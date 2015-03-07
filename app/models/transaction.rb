class Transaction < ActiveRecord::Base
  belongs_to :user
  has_one :saving
  delegate :session, to: :user

  def similar_transactions
    session.similar_transactions([co_transaction_id]).map do |co_transaction_id|
        Transaction.find_by_co_transaction_id(co_transaction_id)
    end
  end
end
