# frozen_string_literal: true

# application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def ensure_user_session
    unauthorized unless logged_in?
  end
end
