# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe ::UsersController, type: :controller do
  let(:user) { instance_double(::User, id: 1, email: 'test1@mail.com', password: 'test123') }
  let(:current_user) { instance_double(::User, id: 1, email: 'test2@mail.com', password: 'test123') }

  before do
    allow(::User).to receive(:find).and_return(user)
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe '#index' do
    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        get :index
        expect(flash[:danger]).to eq message
        expect(response).to redirect_to root_path
      end
    end

    context 'when user authorized' do
      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
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

    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        get :show, params: { id: 1 }
        expect(flash[:danger]).to eq message
        expect(response).to redirect_to root_path
      end
    end

    context 'when user authorized' do
      before { allow(user).to receive(:decorate) }

      it 'renders the show template' do
        expect(User).to receive(:find).and_return(user)

        get :show, params: { id: 1 }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#edit' do
    let(:user) { instance_double(::User) }

    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        get :edit, params: { id: 1 }
        expect(flash[:danger]).to eq message
        expect(response).to redirect_to root_path
      end
    end

    context 'when user authorized' do
      before { allow(user).to receive(:decorate) }

      it 'renders the edit template' do
        expect(User).to receive(:find).and_return(user)

        get :edit, params: { id: 1 }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#update' do
    let(:params) do
      {
        id: 1,
        user: {
          email: 'test@email.com',
          password: 'test123',
          password_confirmation: 'test123',
          role_names: %w[admin]
        }
      }
    end
    let(:user) { instance_double(::User, id: 1, roles: [roles]) }
    let(:roles) { instance_double(::Role, name: 'member') }

    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        patch :update, params: params
        expect(flash[:danger]).to eq(message)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      context 'when update fails' do
        before do
          allow(::User).to receive(:find).and_return(user)
          allow(user).to receive(:update).and_return(false)
          allow(user).to receive_message_chain(:errors, :full_messages, :join).and_return('Some error')
          allow(user).to receive_message_chain(:decorate, :formatted_role_names).and_return(['Admin'])
          allow(user).to receive(:remove_role).with('member')
          allow(user).to receive(:add_role).with('admin')
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
          allow(user).to receive_message_chain(:decorate, :formatted_role_names).and_return(['Admin'])
          allow(user).to receive(:remove_role).with('member')
          allow(user).to receive(:add_role).with('admin')
        end

        it 'flashes success and redirects to the user_path' do
          patch :update, params: params
          expect(flash[:success]).to eq('Successfully updated user')
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
