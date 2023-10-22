# frozen_string_literal: true

# user decorator
class UserDecorator < ApplicationDecorator
  delegate_all

  def formatted_role_names
    role_names.split('|').reject(&:empty?).map(&:titleize).join(', ')
  end
end
