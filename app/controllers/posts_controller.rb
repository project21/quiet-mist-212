class PostsController < ApplicationController
  respond_to :json

  def index
    respond_with Post.for_user(current_user)
  end

  def create
    @post = current_user.posts.build(params[:post].merge(:user => current_user))
    if @post.save
      respond_with @post
    else
      respond_with @post.errors, :status => :unprocessable_entity
    end
  end
end
