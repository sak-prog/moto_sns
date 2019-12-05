require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:users) { create_list(:user, 9) }
  let!(:post) { create(:post, user: user) }
  let!(:posts) { create_list(:post, 12, user: user) }

  describe "GET #index" do
    before do
      get :index
    end

    it "レスポンスが成功する" do
      expect(response).to have_http_status(:success)
    end

    it "ユーザーを表示させる" do
      expect(assigns(:users)).to include(user)
    end

    it "ユーザーは9件まで表示される" do
      expect(assigns(:users).length).to eq 9
    end
  end

  describe "GET #show" do
    before do
      get :show, params: { id: user.id }
    end

    it "レスポンスが成功する" do
      expect(response).to have_http_status(:success)
    end

    it "ユーザーを表示させる" do
      expect(assigns(:user)).to match(user)
    end

    it "投稿を表示させる" do
      expect(assigns(:posts)).to include(post)
    end

    it "投稿は12件まで表示される" do
      expect(assigns(:posts).length).to eq 12
    end
  end
end
