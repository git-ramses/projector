# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::SessionsController, type: :controller do
  let(:current_user) do
    instance_double(
      ::User,
      id: 1,
      email: 'test1@email.com',
      password: 'test123'
    )
  end

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(::User).to receive(:find_by).with({email: 'test1@email.com'}).and_return(current_user)
  end

  describe '#create' do
    let(:params) { { email: current_user.email, password: current_user.password } }

    context 'unauthorized user' do
      let(:message) do
        'Provided credentials not recognized. Please try again or register below.'
      end

      before { allow(current_user).to receive(:authenticate).and_return(false) }

      it 'redirects to sign_in path and renders error message' do
        post :create, params: params

        expect(flash[:danger]).to eq(message)
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'authorized user' do
      let(:message) { 'Successfully signed in!' }

      before { allow(current_user).to receive(:authenticate).and_return(true) }

      it 'logs in the user, flashes succeed and redirects to the user path' do
        post :create, params: params

        expect(flash[:success]).to eq(message)
        expect(response).to redirect_to user_path(current_user)
      end
    end
  end

  describe '#destroy' do
    let(:message) { "Successfully signed out!" }

    it "logs out the user, flashes success and redirects to root_path" do
      delete :destroy

      expect(flash[:success]).to eq(message)
      expect(response).to redirect_to root_path
    end
  end
end
