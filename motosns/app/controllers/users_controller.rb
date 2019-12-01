class UsersController < ApplicationController
  MAX_USER = 9
  MAX_POST = 12

  def index
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(search_params)
    else
      @q = User.ransack
    end
    @users = @q.result(distinct: true).page(params[:page]).per(MAX_USER)
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

  private

  def search_params
    params.require(:q).permit(:name_or_introduce_or_motorcycle_cont, :manufacturers_id_eq)
  end
end
