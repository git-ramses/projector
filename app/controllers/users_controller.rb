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

  def show
    @user = @user.decorate
  end

  def edit
    @user = @user.decorate
  end

  def update
    handle_role_names

    if @user.update(user_params)
      flash[:success] = 'Successfully updated user'
      redirect_to user_path(@user)
    else
      redirect_to edit_user_path(@user)
      flash[:danger] = @user.errors.full_messages.join(', ')
    end
  end

  private

  def handle_role_names
    return nil unless roles_changed?

    roles = params[:user][:role_names].reject(&:empty?)

    @user.roles.each { |role| @user.remove_role(role.name) } if roles.present?
    roles.each { |role| @user.add_role(role.downcase) }
  end

  def roles_changed?
    role_names_in_params = params[:user][:role_names].reject(&:empty?)
    stored_role_names = @user.decorate.formatted_role_names.split(',')

    role_names_in_params != stored_role_names
  end

  def load_user_for_create
    @user = User.new(user_params)
  end

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role_names, :password, :password_confirmation, :avatar)
  end
end
