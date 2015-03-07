module V1
  class UsersController < V1Controller
    def create
      user = User.new(user_params)

      if user.has_capital_one_token? && user.save
        login!(user)
        render json: user, stats: :created
      else
        puts user.errors.full_messages
        render json: { error: { message: "Invalid login credentials" } }, stats: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end