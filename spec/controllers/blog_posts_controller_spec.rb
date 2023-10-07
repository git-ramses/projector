# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe ::BlogPostsController, type: :controller do
  let(:current_user) { instance_double(::User, id: 1, email: 'test1@email.com', password: 'test123') }
  let(:blog_post) { instance_double(::BlogPost, id: 1, subject: 'test', description: 'something') }

  before do
    allow(::BlogPost).to receive(:find).and_return(blog_post)
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe '#index' do
    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        get :index
        expect(flash[:danger]).to eq(message)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      it 'renders index' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end
  end

  describe '#new' do
    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        get :new
        expect(flash[:danger]).to eq(message)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      it 'renders new' do
        get :new
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#create' do
    let(:params) do
      {
        blog_post: {
          subject: 'test',
          description: 'something'
        }
      }
    end

    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        post :create, params: params
        expect(flash[:danger]).to eq(message)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      context 'when create fails' do
        before do
          allow(::BlogPost).to receive(:new).and_return(blog_post)
          allow(blog_post).to receive(:save).and_return(false)
          allow(blog_post).to receive_message_chain(:errors, :full_messages, :join).and_return('Some error')
        end

        it 'flashes an error and renders new' do
          post :create, params: params
          expect(flash[:danger]).to eq('Some error')
          expect(response).to render_template(:new)
        end
      end

      context 'when create succeeds' do
        before do
          allow(::BlogPost).to receive(:new).and_return(blog_post)
          allow(blog_post).to receive(:save).and_return(true)
        end

        it 'creates the blog post' do
          post :create, params: params
          expect(flash[:success]).to eq('Successfully created post!')
          expect(response).to redirect_to blog_post_path(blog_post)
        end
      end
    end
  end

  describe '#show' do
    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        get :show, params: { id: 1 }
        expect(flash[:danger]).to eq(message)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      it 'renders show' do
        expect(::BlogPost).to receive(:find).and_return(blog_post)
        get :show, params: { id: 1 }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#edit' do
    context 'when user unauthorized' do
      let(:current_user) { nil }
      let(:message) { 'You do not have permission to access this page' }

      it 'renders unauthorized' do
        get :edit, params: { id: 1 }
        expect(flash[:danger]).to eq(message)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user authorized' do
      it 'renders edit' do
        expect(::BlogPost).to receive(:find).and_return(blog_post)
        get :edit, params: { id: 1 }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#update' do
    let(:params) do
      {
        id: 1,
        blog_post: {
          subject: 'test',
          description: 'something'
        }
      }
    end

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
          allow(::BlogPost).to receive(:new).and_return(blog_post)
          allow(blog_post).to receive(:update).and_return(false)
          allow(blog_post).to receive_message_chain(:errors, :full_messages, :join).and_return('Some error')
        end

        it 'redirects to edit_blog_post_path' do
          patch :update, params: params
          expect(flash[:danger]).to eq('Some error')
          expect(response).to redirect_to edit_blog_post_path(blog_post)
        end
      end

      context 'when update succeeds' do
        before do
          allow(::BlogPost).to receive(:new).and_return(blog_post)
          allow(blog_post).to receive(:update).and_return(true)
        end

        it 'updates the blog post' do
          patch :update, params: params
          expect(flash[:success]).to eq('Successfully updated post!')
          expect(response).to redirect_to blog_post_path(blog_post)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
