require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #about" do
    before do
      get :about
    end

    it "レスポンスが成功する" do
      expect(response).to have_http_status(:success)
    end

    it "aboutテンプレートを表示させる" do
      expect(response).to render_template :about
    end
  end

  describe "GET #index" do
    before do
      get :index
    end

    it "レスポンスが成功する" do
      expect(response).to have_http_status(:success)
    end

    it "indexテンプレートを表示させる" do
      expect(response).to render_template :index
    end
  end
end
