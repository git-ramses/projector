# frozen_string_literal: true

# User representation
class User < ApplicationRecord
  # adds virtual attributes for authentication
  has_secure_password
  has_many :roles

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  def role_names=(roles)
    roles.split('|').reject(&:empty?).each do |role|
      ::Role.create!(name: role, user_id: id)
    end
  end

  def role_names
    roles.empty? ? '' : "|#{roles.pluck(:name).join('|')}|"
  end

  def add_role(role)
    roles.create!(name: role.to_s)
  end

  def remove_role(role)
    roles.find_by(name: role.to_s).delete
    reload
  end

  def admin?
    roles.pluck(:name).include?(::Role::ADMIN)
  end

  def readonly?
    roles.pluck(:name).include?(::Role::READONLY)
  end
end
