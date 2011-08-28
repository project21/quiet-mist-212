class PostsController < ApplicationController
  respond_to :json

  def index
    posts = Post.for_user(current_user).includes(:user).includes(:replies => :user)
    #replies = Post.where(:reply_id => posts.map(&:id)).includes(:user)
    #respond_with(posts.to_json(:include => [:user, {:replies => :user}]))
    respond_with(posts.to_json(:include => [:user, :replies]))
  end

  def create
    post_params.delete('user_id')
    @post = current_user.posts.build(post_params.merge(:user => current_user))
    if @post.save
      respond_with @post
    else
      respond_with @post, :status => :unprocessable_entity
    end
  end

protected
  def post_params
    @post_params ||= params[:post] || {}
  end
end
