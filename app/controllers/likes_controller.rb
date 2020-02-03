class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.find_or_create_by(post_id: params[:post_id])
    @likes = Like.where(post_id: params[:post_id])
    @post = Post.find(params[:post_id])
  end

  def destroy
    like = current_user.likes.find_by(post_id: params[:post_id])
    like.destroy
    @likes = Like.where(post_id: params[:post_id])
    @post = Post.find(params[:post_id])
  end
end
