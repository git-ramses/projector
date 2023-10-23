# frozen_string_literal: true

# controller of blog posts
class BlogPostsController < ApplicationController
  before_action :find_blog_post_for_create, only: %i[create]
  before_action :find_blog_post, only: %i[show edit update]
  before_action :ensure_user_session

  def index
    @blog_posts = BlogPost.all
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    if @blog_post.save
      redirect_to blog_post_path(@blog_post)
      flash[:success] = 'Successfully created post!'
    else
      render :new
      flash[:danger] = @blog_post.errors.full_messages.join(', ')
    end
  end

  def show; end

  def edit; end

  def update
    if @blog_post.update(blogpost_params)
      flash[:success] = 'Successfully updated post!'
      redirect_to blog_post_path(@blog_post)
    else
      redirect_to edit_blog_post_path(@blog_post)
      flash[:danger] = @blog_post.errors.full_messages.join(', ')
    end
  end

  private

  def find_blog_post_for_create
    @blog_post = ::BlogPost.new(blogpost_params.merge(user: current_user))
  end

  def find_blog_post
    @blog_post = ::BlogPost.find(params[:id])
  end

  def blogpost_params
    params.require(:blog_post).permit(:subject, :description, :avatar)
  end
end
