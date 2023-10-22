# frozen_string_literal: true

# Role representation
class Role < ApplicationRecord
  ADMIN = 'admin'
  MEMBER = 'member'
  VALID_ROLES = [ADMIN, MEMBER].freeze

  belongs_to :user

  validates :name, inclusion: { in: VALID_ROLES, message: '%<value>s is not a valid role' }
end
