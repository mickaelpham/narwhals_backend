module V1
  class SessionController < V1Controller
    def create
    	user = User.find_by_email(session_params[:email])

    	if user
    		render json: user, status: :ok
    	else
    		render json: { error: { message: "Invalud user credentials" } }, status: :unprocessable_entity
    	end
    end

    private

    def session_params
      params.require(:user).permit(:email)
    end
  end
end