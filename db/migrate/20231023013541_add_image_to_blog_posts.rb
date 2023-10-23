# frozen_string_literal: true

# add avatar to blog_posts
class AddImageToBlogPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_posts, :avatar, :string
  end
end
