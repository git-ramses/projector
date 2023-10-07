# frozen_string_literal: true

# model for blog_posts db table
class BlogPost < ApplicationRecord
  belongs_to :user

  validates :subject, presence: true
  validates :description, presence: true
end
