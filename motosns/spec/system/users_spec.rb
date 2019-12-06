require 'rails_helper'

RSpec.describe "Users", type: :system do
  include Devise::Test::IntegrationHelpers

  let!(:manufacturer) { create(:manufacturer, name: "MOTO") }
  let!(:manufacturer_user) { create(:manufacturer_user, manufacturer_id: manufacturer.id, user_id: user.id) }
  let!(:user) { create(:user, name: "moto", introduce: "ruby", manufacturers: [manufacturer], created_at: 1.day.ago) }
  let!(:other_user) { create(:user, name: "sns", motorcycle: "rails") }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }
  let!(:posts) { create_list(:post, 2, user: user, created_at: 1.day.ago) }

  before do
    sign_in user
    visit user_path(user)
  end

  scenario "ユーザー情報を変更する" do
    expect(page).to have_title "#{user.name} | MOTO SNS"
    expect(page).to have_selector 'h1', text: user.name
    click_on "プロフィールを編集"
    fill_in "名前", with: "test-user"
    fill_in "自己紹介", with: "hello"
    check "HONDA"
    fill_in "車種", with: "test"
    click_on "更新"
    expect(user.reload.name).to eq "test-user"
    expect(user.reload.introduce).to eq "hello"
    expect(page).to have_content "HONDA"
    expect(user.reload.motorcycle).to eq "test"
  end

  scenario "マイページには自分の投稿のみ表示される" do
    expect(page).to have_content post.content
    expect(page).not_to have_content other_post.content
  end

  scenario "ユーザー一覧ページから、他ユーザーの詳細ページに移行する" do
    click_on "ユーザー一覧"
    expect(page).to have_current_path(users_path)
    expect(page).to have_title "ユーザー一覧 | MOTO SNS"
    expect(page).to have_selector '.card-body', text: user.name
    expect(page).to have_selector '.card-body', text: user.introduce
    expect(page).to have_selector '.card-body', text: user.created_at.strftime("%Y-%m-%d %H:%M")
    click_on other_user.name
    expect(page).to have_selector '.profile-wrap', text: other_user.name
    expect(page).to have_content other_post.content
    expect(page).to have_button 'フォローする'
  end

  scenario "他ユーザーでログインし、ユーザー一覧ページにアクセスする" do
    click_on "ログアウト"
    expect(page).to have_current_path(root_path)
    sign_in other_user
    visit user_path(other_user.id)
    expect(page).to have_current_path(user_path(other_user.id))
    visit users_path
    expect(page).to have_current_path(users_path)
    expect(page).to have_selector '.card-body', text: user.name
    expect(page).to have_selector '.card-body', text: user.introduce
    expect(page).to have_selector '.card-body', text: user.created_at.strftime("%Y-%m-%d %H:%M")
    expect(page).to have_selector '.card-body', text: other_user.name
    expect(page).to have_selector '.card-body', text: other_user.introduce
    expect(page).to have_selector '.card-body', text: other_user.created_at.strftime("%Y-%m-%d %H:%M")
    click_on "ログアウト"
    expect(page).to have_current_path(root_path)
  end

  scenario "他ユーザーをフォローする" do
    visit users_path
    expect(page).to have_current_path(users_path)
    click_on other_user.name
    expect(page).to have_current_path(user_path(other_user.id))
    expect(page).to have_selector '.profile-wrap', text: other_user.name
    expect(page).to have_button "フォローする"
    before_count = Relationship.count("follower_id")
    click_on "フォローする"
    expect(page).to have_button "フォロー中"
    expect(Relationship.count).to eq before_count + 1
    click_on "フォロー中"
    expect(Relationship.count).to eq before_count
  end

  scenario "フォローページにフォローしたユーザーが表示される" do
    visit following_user_path(user)
    expect(page).not_to have_content other_user.name
    visit user_path(other_user.id)
    click_on "フォローする"
    visit following_user_path(user)
    expect(page).to have_content other_user.name
  end

  scenario "フォロワーページにフォロワーが表示される" do
    visit followers_user_path(other_user)
    expect(page).not_to have_content user.name
    click_on "フォローする"
    expect(page).to have_content user.name
  end

  scenario "いいねした投稿を表示する" do
    find('#like-tab').click
    expect(page).not_to have_content other_post.content
    visit post_path(other_post.id)
    click_on "いいね"
    visit user_path(user)
    find('#like-tab').click
    expect(page).to have_content other_post.content
  end

  scenario "検索したユーザーを表示する" do
    visit users_path
    expect(page).to have_content user.name
    expect(page).to have_content other_user.name
    select "MOTO"
    click_on "検索"
    expect(page).to have_content user.name
    expect(page).not_to have_content other_user.name
    fill_in "キーワードを入力して下さい", with: "moto"
    select "指定なし"
    click_on "検索"
    expect(page).to have_content user.name
    expect(page).not_to have_content other_user.name
    fill_in "キーワードを入力して下さい", with: "rails"
    click_on "検索"
    expect(page).not_to have_content user.name
    expect(page).to have_content other_user.name
  end

  scenario "ユーザーは降順に表示される" do
    visit users_path
    within ".users", match: :first do
      expect(page).to have_content other_user.name
    end
  end

  scenario "投稿は降順に表示される" do
    within ".card", match: :first do
      expect(page).to have_content post.content
    end
  end
end
