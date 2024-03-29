class Transaction < ActiveRecord::Base
  belongs_to :user
  has_one :saving, :foreign_key => 'co_transaction_id'
  delegate :session, to: :user
  scope :debit, -> { where('amount < 0') }

  def similar_transactions
    session.similar_transactions([co_transaction_id]).map do |co_transaction_id|
        Transaction.find_by_co_transaction_id(co_transaction_id)
    end
  end
end
