module V1
  class SavingsController < V1Controller
    def index
    end

    def create
      saving = Saving.new(saving_params)

      if saving.save
        render json: saving, status: :created
      else
        render json: { error: { messages: ['Invalid transaction or calculation'] } }, status: :unprocessable_entity
      end
    end

    def show
      saving = Saving.find(params[:id])

      if saving
        render json: saving
      else
        render json: { error: { messages: ['Could not retrieve saving'] } }, status: :unprocessable_entity
      end
    end

    private

    def saving_params
      params.require(:saving).permit(:transaction_id, :frequency, :time_period, :preview_cost)
    end
  end
end
