# frozen_string_literal: true

# Controls requests around User
class UsersController < ApplicationController
  before_action :load_user_for_create, only: %i[create]
  before_action :load_user, only: %i[show edit update]
  before_action :ensure_user_session, except: %i[new create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
      flash[:success] = 'Successfully created account'
    else
      redirect_to sign_up_path
      flash[:danger] = @user.errors.full_messages.join(', ')
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'Successfully updated user'
      redirect_to user_path(@user)
    else
      redirect_to edit_user_path(@user)
      flash[:danger] = @user.errors.full_messages.join(', ')
    end
  end

  private

  def load_user_for_create
    @user = User.new(user_params)
  end

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
