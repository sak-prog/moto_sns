require 'rails_helper'

RSpec.describe "Home", type: :system do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit root_path
  end

  scenario "アクセスした際にリンクが表示される" do
    expect(page).to have_title "ホーム | MOTO SNS"
    within ".box" do
      expect(page).to have_link "新規登録"
      expect(page).to have_link "ログイン"
    end
    within ".navbar-nav", match: :first do
      expect(page).to have_link "このサービスについて"
      expect(page).to have_link "投稿一覧"
      expect(page).to have_link "ユーザー一覧"
      expect(page).to have_link "サインイン"
      expect(page).to have_link "ログイン"
    end
  end

  scenario "ログインするとリンクが変わる" do
    sign_in user
    visit posts_path
    within ".navbar-nav", match: :first do
      expect(page).not_to have_link "サインイン"
      expect(page).not_to have_link "ログイン"
      expect(page).to have_link "マイページ"
      expect(page).to have_link "ログアウト"
    end
  end

  scenario "aboutをクリックすると、アプリ詳細ページに移行する" do
    click_on "このサービスについて"
    expect(page).to have_current_path(about_path)
    expect(page).to have_title "概要 | MOTO SNS"
  end

  scenario "ログインを押すとログイン画面に移行する" do
    within ".box" do
      click_on "ログイン"
    end
    expect(page).to have_current_path(new_user_session_path)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    within ".login-button" do
      click_on "ログイン"
    end
    expect(page).to have_current_path(root_path)
  end

  scenario "サインインを押すと新規登録画面に移行する" do
    click_on "新規登録"
    expect(page).to have_current_path(new_user_registration_path)
    fill_in "メールアドレス", with: "test_motosns@example.com"
    fill_in "名前", with: user.name
    fill_in "パスワード", with: user.password
    fill_in "パスワードの確認", with: user.password_confirmation
    click_on "新規登録"
    expect(page).to have_current_path(root_path)
  end

  scenario "フォローしたユーザーの投稿がフィードに表示される" do
    sign_in user
    visit root_path
    expect(page).to have_content post.content
    expect(page).not_to have_content other_post.content
    visit users_path
    click_on other_user.name
    click_on "フォローする"
    visit root_path
    expect(page).to have_content other_post.content
  end
end
