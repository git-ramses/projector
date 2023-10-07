# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::BlogPost, type: :model do
  describe 'validations' do
    let!(:user) { User.new }

    it 'is valid with valid attributes' do
      blog_post = described_class.new(user: user, subject: 'test', description: 'something')
      expect(blog_post).to be_valid
    end

    it 'is invalid without a user' do
      blog_post = described_class.new(user: nil, subject: 'test', description: 'something')
      expect(blog_post).not_to be_valid
    end

    it 'is invalid without a subject' do
      blog_post = described_class.new(user: user, subject: nil, description: 'something')
      expect(blog_post).not_to be_valid
    end

    it 'is invalid without a description' do
      blog_post = described_class.new(user: user, subject: 'test', description: nil)
      expect(blog_post).not_to be_valid
    end
  end
end
