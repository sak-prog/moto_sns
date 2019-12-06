require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "GET #index" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:post) { create(:post, user: user) }
    let!(:other_post) { create(:post, user: other_user, created_at: 1.day.ago) }
    let!(:posts) { create_list(:post, 11, user: user, created_at: 2.day.ago) }

    before do
      get :index
    end

    it "レスポンスが成功する" do
      expect(response).to have_http_status(:success)
    end

    it "indexテンプレートの表示させる" do
      expect(response).to render_template :index
    end

    it "userのpostを表示する" do
      expect(assigns(:posts)).to include(post)
    end

    it "other_userの投稿を表示する" do
      expect(assigns(:posts)).to include(other_post)
    end

    it "投稿は12件まで表示される" do
      expect(assigns(:posts).length).to eq 12
    end
  end

  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }

    before do
      get :show, params: { id: post.id }
    end

    it "レスポンスが成功する" do
      expect(response).to be_successful
    end

    it "showテンプレートの表示させる" do
      expect(response).to render_template :show
    end

    it "投稿を表示する" do
      expect(assigns(:post)).to match(post)
    end
  end

  describe "GET #new" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }

    context "ログイン済みのユーザー" do
      before do
        sign_in user
        get :new, params: {}
      end

      it "レスポンスが成功する" do
        expect(response).to be_successful
      end

      it "@postが定義される" do
        expect(assigns(:post)).to be_a_new Post
      end

      it "newテンプレートを表示させる" do
        expect(response).to render_template :new
      end
    end

    context "ログインしていないユーザー" do
      before do
        get :new, params: {}
      end

      it "レスポンスが失敗する" do
        expect(response).not_to be_successful
      end

      it "@postが定義されない" do
        expect(assigns(:post)).not_to be_a_new Post
      end

      it "ログインページにリダイレクトする" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #create" do
    let!(:user) { create(:user) }
    let(:post_attributes) { attributes_for(:post) }

    context "ログイン済みのユーザー" do
      before do
        sign_in user
      end

      it "レスポンスが成功する" do
        expect(response).to be_successful
      end

      it '投稿を保存する' do
        expect do
          post :create, params: { post: post_attributes }
        end.to change(Post, :count).by(1)
      end

      it '投稿に成功したら、投稿一覧ページにリダイレクトする' do
        post :create, params: { post: post_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "ログインしていないユーザー" do
      it "レスポンスが失敗する" do
        post :create, params: { content: post_attributes }
        expect(response).not_to be_successful
      end

      it "ログインページにリダイレクトする" do
        post :create, params: { post: post_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #destroy" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }

    context "ログイン済みのユーザー" do
      before do
        sign_in user
      end

      it "レスポンスが成功する" do
        expect(response).to be_successful
      end

      it "投稿を削除する" do
        expect do
          delete :destroy, params: { id: post.id }
        end.to change(Post, :count).by(-1)
      end

      it "削除に成功したら、投稿一覧ページにリダイレクトする" do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "ログインしていないユーザー" do
      it "レスポンスが失敗する" do
        delete :destroy, params: { id: post.id }
        expect(response).not_to be_successful
      end

      it "ログインページにリダイレクトする" do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
