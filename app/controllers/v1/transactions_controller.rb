module V1
  class TransactionsController < V1Controller
    def index
      current_user.fetch_transactions
      transactions = current_user.transactions.where(query_params)

      render json: transactions, status: :ok
    end

    def similar
      transaction = Transaction.find(params[:id])

      render json: transaction.similar_transactions, status: :ok
    end

    private

    def query_params
      params.permit(:categorization)
    end
  end
end