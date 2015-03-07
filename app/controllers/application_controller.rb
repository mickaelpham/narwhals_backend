class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def current_user
    @current_user ||= (User.find_by_session_token(session[:session_token]) ||
    User.find_by_session_token(params[:session_token]))
  end

  def login!(user)
    @current_user = user
    session[:session_token] = current_user.reset_session_token!
  end

  def logout!
    current_user.reset_session_token!
    @current_user = nil
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  def ensure_logged_in
    unless current_user
      render json: { error: { messages: ["Please log in"] } }, status: :unauthorized
    end
  end
end
