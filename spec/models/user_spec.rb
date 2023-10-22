# frozen_string_literal: true

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

  describe '#role_names=' do
    it 'creates a role for the provided roles' do
      user = described_class.create(email: 'test1@email.com', password: 'test123')
      roles = '|admin|'

      expect(::Role).to receive(:create!).with(name: 'admin', user_id: user.id)
      expect(user.role_names=roles).to eq('|admin|')
    end
  end

  describe '#add_role' do
    it 'creates a role for the provided role' do
      user = described_class.create(email: 'test1@email.com', password: 'test123', role_names: '')

      user.add_role('admin')
      expect(user.role_names).to eq('|admin|')
    end
  end

  describe '#remove_role' do
    it 'removes the provided role' do
      user = described_class.create(email: 'test1@email.com', password: 'test123')
      ::Role.create(name: 'admin', user_id: user.id)
      ::Role.create(name: 'readonly', user_id: user.id)

      user.remove_role('admin')
      expect(user.role_names).to eq('|readonly|')
    end
  end

  describe '#admin?' do
    context 'when roles includes admin role' do
      let!(:user) { described_class.create(email: 'test1@email.com', password: 'test123') }
      let!(:role) { ::Role.create(name: 'admin', user_id: user.id) }

      it 'returns true' do
        expect(user.admin?).to eq(true)
      end
    end

    context 'when roles excludes admin role' do
      let!(:user) { described_class.create(email: 'test1@email.com', password: 'test123') }
      let!(:role) { ::Role.create(name: 'readonly', user_id: user.id) }

      it 'returns false' do
        expect(user.admin?).to eq(false)
      end
    end
  end

  describe '#readonly?' do
    context 'when roles includes readonly role' do
      let!(:user) { described_class.create(email: 'test1@email.com', password: 'test123') }
      let!(:role) { ::Role.create(name: 'readonly', user_id: user.id) }

      it 'returns true' do
        expect(user.readonly?).to eq(true)
      end
    end

    context 'when roles excludes readonly role' do
      let!(:user) { described_class.create(email: 'test1@email.com', password: 'test123') }
      let!(:role) { ::Role.create(name: 'admin', user_id: user.id) }

      it 'returns false' do
        expect(user.readonly?).to eq(false)
      end
    end
  end
end
