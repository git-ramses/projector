# frozen_string_literal: true

# adds table to store blog post data
class CreateBlogPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :blog_posts do |t|
      t.integer(:user_id)
      t.string(:subject)
      t.string(:description)
      t.timestamps
    end
  end
end
