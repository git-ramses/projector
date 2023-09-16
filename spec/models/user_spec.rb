# frozen_string_literal

require 'rails_helper'

RSpec.describe ::User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = described_class.new(email: 'test1@email.com', password: 'test123')
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = described_class.new(email: nil, password: 'test123')
      expect(user).to_not be_valid
    end

    it 'is invalid if email already exists for another user' do
      described_class.create!(email: 'test1@emai.com', password: 'test123')
      our_user = described_class.new(email: 'test1@emai.com', password: 'test123')
      expect(our_user).to_not be_valid
    end

    it 'is invalid if email is not in the proper format' do
      user = described_class.new(email: 'test1email.com', password: 'test123')
      expect(user).to_not be_valid
    end
  end
end
