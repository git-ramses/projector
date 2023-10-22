# frozen_string_literal: true

# adds reference to user on roles table
class AddUserIdToRoles < ActiveRecord::Migration[7.0]
  def change
    add_reference :roles, :user, index: true
  end
end
