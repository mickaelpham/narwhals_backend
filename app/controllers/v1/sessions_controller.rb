module V1
  class SessionsController < V1Controller
    def create
      user = User.find_by_email_and_password(session_params[:email], session_params[:password])

      if user
        login!(user)
        puts user.fetch_transactions
        render json: user, status: :ok
      else
        render json: { error: { message: "Invalud user credentials" } }, status: :unprocessable_entity
      end
    end

    def destroy
      logout!
      render json: {}
    end

    private

    def session_params
      params.require(:user).permit(:email, :password)
    end
  end
end