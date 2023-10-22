# frozen_string_literal: true

# creates roles table to store role data for users
class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string(:name)
      t.timestamps
    end
  end
end
