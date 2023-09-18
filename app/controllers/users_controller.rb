# frozen_string_literal: true

# Controls requests around User
class UsersController < ApplicationController
  before_action :load_user, only: %i[show edit update]

  def index
    # TODO: add authorization
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      # redirect_to root_path
      flash[:success] = 'Successfully created account'
    else
      redirect_to sign_up_path
      flash[:danger] = @user.errors.full_messages.join(', ')
    end
  end

  # TODO: add authorization
  def show; end

  # TODO: add authorization
  def edit; end

  def update
    # TODO: add authorization
    if @user.update(user_params)
      flash[:success] = 'Successfully updated user'
      redirect_to user_path(@user)
    else
      redirect_to edit_user_path(@user)
      flash[:danger] = @user.errors.full_messages.join(', ')
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    # strong parameters
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
