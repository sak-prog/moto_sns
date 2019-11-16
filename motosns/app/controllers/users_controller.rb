class UsersController < ApplicationController
  MAX_USER = 9
  MAX_POST = 12

  def index
    @users = User.page(params[:page]).per(MAX_USER)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(MAX_POST)
  end

  def following
    @title = 'フォロー'
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(MAX_USER)
    render 'show_follow'
  end

  def followers
    @title = 'フォロワー'
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(MAX_USER)
    render 'show_follow'
  end
end
