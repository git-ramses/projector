# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe ::UsersController, type: :controller do
  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe '#new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    let(:params) do
      {
        user: {
          email: 'test@email.com',
          password: 'test123',
          password_confirmation: 'test123'
        }
      }
    end
    let(:user) { instance_double(::User, id: 1) }

    context 'when create fails' do
      before do
        allow(::User).to receive(:new).and_return(user)
        allow(user).to receive(:save).and_return(false)
        allow(user).to receive_message_chain(:errors, :full_messages, :join).and_return('Some error')
      end

      it 'flashes an error and redirects to the sign_up path' do
        post :create, params: params
        expect(flash[:danger]).to eq('Some error')
        expect(response).to redirect_to(sign_up_path)
      end
    end

    context 'when create succeeds' do
      before do
        allow(::User).to receive(:new).and_return(user)
        allow(user).to receive(:save).and_return(true)
      end

      it 'creates the user and flashes success' do
        post :create, params: params
        expect(flash[:success]).to eq('Successfully created account')
      end
    end
  end

  describe '#show' do
    let(:user) { instance_double(::User) }

    it 'renders the show template' do
      expect(User).to receive(:find).and_return(user)

      get :show, params: { id: 1 }
      expect(response).to render_template(:show)
    end
  end

  describe '#edit' do
    let(:user) { instance_double(::User) }

    it 'renders the edit template' do
      expect(User).to receive(:find).and_return(user)

      get :edit, params: { id: 1 }
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    let(:params) do
      {
        id: 1,
        user: {
          email: 'test@email.com',
          password: 'test123',
          password_confirmation: 'test123'
        }
      }
    end
    let(:user) { instance_double(::User, id: 1) }

    context 'when update fails' do
      before do
        allow(::User).to receive(:find).and_return(user)
        allow(user).to receive(:update).and_return(false)
        allow(user).to receive_message_chain(:errors, :full_messages, :join).and_return('Some error')
      end

      it 'flashs an error and redirects to the edit_user_path' do
        patch :update, params: params
        expect(flash[:danger]).to eq('Some error')
        expect(response).to redirect_to(edit_user_path(user))
      end
    end

    context 'when update succeeds' do
      before do
        allow(::User).to receive(:find).and_return(user)
        allow(user).to receive(:update).and_return(true)
      end

      it 'flashes success and redirects to the user_path' do
        patch :update, params: params
        expect(flash[:success]).to eq('Successfully updated user')
        expect(response).to redirect_to(user_path(user))
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
