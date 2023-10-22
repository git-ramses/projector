# frozen_string_literal: true

# adds role_names column to users table
class AddRoleNamesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role_names, :string
  end
end
