# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::UserDecorator do
  describe '#formatted_role_names' do
    it 'returns a string of formatted role names' do
      user = ::User.create(email: 'test1@email.com', password: 'test123')
      user.role_names = '|admin|member|'

      expect(user.decorate.formatted_role_names).to eq('Admin, Member')
    end
  end
end
