class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :correct_user, only: :destroy

  MAX_POST = 12

  def index
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = Post.ransack(search_params)
    else
      @q = Post.ransack
    end
    @posts = @q.result(distinct: true).page(params[:page]).per(MAX_POST).order(created_at: "DESC")
  end

  def show
    @post = Post.find(params[:id])
    @like = Like.new
    @comments = @post.comments
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿を作成しました！"
      redirect_to root_path
    else
      flash[:alert] = "投稿に失敗しました"
      redirect_to root_path
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:content, :image, :tag_list)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end

  def search_params
    params.require(:q).permit(:content_or_tags_name_cont)
  end
end
