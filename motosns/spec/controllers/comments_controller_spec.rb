require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:comment_post) { create(:post, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, post_id: comment_post.id) }

  describe "GET #create" do
    let!(:comment_create_params) { { comment: { post_id: comment_post.id, user_id: user.id, content: 'hoge' }, post_id: comment_post.id } }

    context "ログイン済みのユーザー" do
      before do
        sign_in user
      end

      it "レスポンスが成功する" do
        expect(response).to be_successful
      end

      it "投稿に対してコメントをする" do
        expect { post :create, params: comment_create_params }.to change(Comment, :count).by(1)
      end
    end

    context "ログインしていないユーザー" do
      it "コメントに失敗する" do
        post :create, params: comment_create_params
        expect { post :create, params: comment_create_params }.to change(Comment, :count).by(0)
      end

      it "ログインページにリダイレクトする" do
        post :create, params: comment_create_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #destory" do
    let!(:comment_destroy_params) { { post_id: comment_post.id, id: comment.id } }

    context "ログイン済みのユーザー" do
      before do
        sign_in user
      end

      it "レスポンスが成功する" do
        expect(response).to be_successful
      end

      it "投稿のコメントを削除する" do
        expect { delete :destroy, params: comment_destroy_params }.to change(Comment, :count).by(-1)
      end
    end

    context "ログインしていないユーザー" do
      it "コメントの削除に失敗する" do
        expect { delete :destroy, params: comment_destroy_params }.to change(Comment, :count).by(0)
      end

      it "ログインページにリダイレクトする" do
        delete :destroy, params: comment_destroy_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
