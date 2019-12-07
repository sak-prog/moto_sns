require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:like_post) { create(:post, user: user) }

  describe "GET #create" do
    context "ログイン済みのユーザー" do
      before do
        sign_in user
      end

      it "レスポンスが成功する" do
        expect(response).to be_successful
      end

      it "いいねに成功する" do
        expect { post :create, params: { post_id: like_post.id } }.to change(Like, :count).by(1)
      end

      it "いいねは１しか増えない" do
        post :create, params: { post_id: like_post.id }
        expect { post :create, params: { post_id: like_post.id } }.to change(Like, :count).by(0)
      end
    end

    context "ログインしていないユーザー" do
      before do
        post :create, params: { post_id: like_post.id }
      end

      it "レスポンスが失敗する" do
        expect(response).not_to be_successful
      end

      it "いいねに失敗する" do
        expect { post :create, params: { post_id: like_post.id } }.to change(Like, :count).by(0)
      end
    end
  end

  describe "GET #destroy" do
    let!(:like) { create(:like, user_id: user.id, post_id: like_post.id) }

    context "ログイン済みのユーザー" do
      before do
        sign_in user
      end

      it "レスポンスが成功する" do
        expect(response).to be_successful
      end

      it "いいねの削除に成功する" do
        expect { delete :destroy, params: { post_id: like_post.id, user_id: user.id, id: like.id } }.to change(Like, :count).by(-1)
      end
    end

    context "ログインしていないユーザー" do
      before do
        delete :destroy, params: { post_id: like_post.id, user_id: user.id, id: like.id }
      end

      it "レスポンスが失敗する" do
        expect(response).not_to be_successful
      end

      it "いいねの削除に失敗する" do
        expect { delete :destroy, params: { post_id: like_post.id, user_id: user.id, id: like.id } }.to change(Like, :count).by(0)
      end
    end
  end
end
