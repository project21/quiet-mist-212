class PostsController < ApplicationController
  respond_to :json

  def index
    posts = get_posts
    respond_with make_json_tree posts
      #posts.to_json(:methods => :user, :include => {:replies => {:include => :user}}))
  end

  def latest
    head :unprocessable_entity unless max_id = params[:max_id]
    posts = get_posts.where {id > max_id}
    respond_with make_json_tree posts
  end

  def create
    post_params.delete('user_id')
    post_params.delete('reply')
    @post = current_user.posts.build(post_params.merge(:user => current_user))
    if @post.save
      respond_with @post
    else
      respond_with @post, :status => :unprocessable_entity
    end
  end

protected

  def get_posts
    Post.for_user(current_user).top_level.includes(:user).includes(:replies => :user)
  end

  def make_json_tree posts
    posts.map do |post|
      post.attributes.merge(:user => post.user, :replies => make_json_tree(post.replies))
    end
  end
    #post_lookup = Hash.new
    #posts = posts.each do |post|
      #post_lookup[post.id] = post
    #end.reject do |post|
      #if post.reply_id
        #post_lookup[post.reply_id].replies << post
        #true
      #else
        #false
      #end
    #end
  def post_params
    @post_params ||= params[:post] || {}
  end
end
