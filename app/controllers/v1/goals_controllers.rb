module V1
  class GoalsController < V1Controller
    before_action :ensure_logged_in

    def create
      goal = Goal.new(goal_params)

      if goal.save
        render json: goal, stats: :created
      else
        render json: { error: { message: "Invalid login credentials" } }, stats: :unprocessable_entity
      end
    end

    def index
      render json: current_user.goals, status: :ok
    end

    private

    def goal_params
      params.require(:goal).permit(:email, :password)
    end
  end
end