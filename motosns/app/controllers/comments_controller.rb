class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post=Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    if @comment.save
      flash[:notice] = "コメントしました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントに失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:notice] = "コメントを削除しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントの削除に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.required(:comment).permit(:user_id, :content)
  end
end
