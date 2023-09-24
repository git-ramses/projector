# frozen_string_literal: true

# sessions helper
module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def unauthorized
    flash[:danger] = 'You do not have permission to access this page'
    redirect_to root_path
  end
end
