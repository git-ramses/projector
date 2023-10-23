# frozen_string_literal: true

# model for blog_posts db table
class BlogPost < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :subject, presence: true
  validates :description, presence: true
end
