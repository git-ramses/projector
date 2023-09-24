# frozen_string_literal: true

# controls user session requests
class SessionsController < ApplicationController
  before_action :load_user, only: %i[create]

  def new; end

  def create
    if !!@user && @user.authenticate(params[:password])
      sign_in(@user)
      flash[:success] = 'Successfully signed in!'
      redirect_to(user_path(@user))
    else
      flash[:danger] = 'Provided credentials not recognized. Please try again or register below.'
      redirect_to(sign_in_path)
    end
  end

  def destroy
    sign_out
    flash[:success] = 'Successfully signed out!'
    redirect_to(root_path)
  end

  private

  def load_user
    @user = ::User.find_by(email: params[:email])
  end
end
