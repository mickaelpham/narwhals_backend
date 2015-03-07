module V1
  class UsersController < V1Controller
    def create
      user = User.new(user_params)

      if user.save
        login!(user)
        render json: user, status: :created
      elsif user.errors[:email] == ["has already been taken"]
        render json: { error: { messages: ["Capitol One account already exists"] } }, status: :unprocessable_entity
      else
        render json: { error: { messages: ["Invalid Capitol One credentials"] } }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
