# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Role, type: :model do
  describe 'validations' do
    let!(:user) { User.create(email: 'test1@email', password: 'test123') }

    it 'is valid with valid attributes' do
      role = described_class.new(name: 'admin', user_id: user.id)
      expect(role).to be_valid
    end

    it 'is invalid without a name' do
      role = described_class.new(name: nil, user_id: user.id)
      expect(role).to_not be_valid
    end

    it 'is invalid with an invalid name' do
      role = described_class.new(name: 'banana', user_id: user.id)
      expect(role).to_not be_valid
    end
  end
end
