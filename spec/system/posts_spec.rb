require 'rails_helper'

RSpec.describe "Posts", type: :system do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user, content: "ruby", tag_list: "rails") }
  let!(:other_post) { create(:post, user: other_user, content: "hello", created_at: 1.day.ago) }
  let!(:comment) { create(:comment, post: post, user: user) }

  before do
    sign_in user
    visit user_path(user)
  end

  scenario "投稿画面から投稿をする" do
    visit new_post_path
    before_count = Post.count
    fill_in "投稿内容", with: "test"
    fill_in "コンマ（,）毎に区切ることで複数投稿することが出来ます。", with: "test"
    attach_file "post[image]", "#{Rails.root}/spec/files/4edb4686db7f80f67fa1bbf916610e97_s.jpg"
    click_on "投稿する"
    expect(current_path).to eq root_path
    expect(page).to have_selector '.card', text: post.user.name
    expect(page).to have_selector '.card', text: post.image
    expect(page).to have_selector '.card', text: post.content
    expect(page).to have_selector '.card', text: post.tag_list
    expect(Post.count).to eq before_count + 1
  end

  scenario "投稿一覧ページから投稿詳細ページに移行する" do
    visit posts_path
    within ".card", match: :first do
      click_on "詳細"
    end
    expect(page).to have_current_path(post_path(post.id))
    expect(page).to have_selector '.card', text: post.user.name
    expect(page).to have_selector '.card', text: post.image
    expect(page).to have_selector '.card', text: post.content
  end

  scenario "投稿の削除を行う" do
    visit posts_path
    before_count = Post.count
    click_on "削除"
    expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか？"
    page.driver.browser.switch_to.alert.accept
    expect(current_path).to eq root_path
    expect(page).not_to have_selector '.card', text: post.user.name
    expect(page).not_to have_selector '.card', text: post.image
    expect(page).not_to have_selector '.card', text: post.content
    expect(Post.count).to eq before_count - 1
  end

  scenario "コメントの削除を行う" do
    visit post_path(post.id)
    expect(page).to have_current_path(post_path(post.id))
    before_count = Comment.count
    click_on "✖︎"
    expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか？"
    page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_selector '.mt-2', text: comment.user.name
    expect(page).not_to have_selector '.mt-2', text: comment.content
    expect(Comment.count).to eq before_count - 1
  end

  scenario "コメントを行う" do
    visit post_path(post.id)
    expect(page).to have_current_path(post_path(post.id))
    before_count = Comment.count
    fill_in "コメント ...", with: "test"
    click_on "コメントする"
    expect(page).to have_selector '.mt-2', text: comment.user.name
    expect(page).to have_selector '.mt-2', text: comment.content
    expect(Comment.count).to eq before_count + 1
  end

  scenario "投稿にいいねを行う" do
    visit post_path(post.id)
    expect(page).to have_current_path(post_path(post.id))
    before_count = Like.count
    expect(page).to have_button "いいね"
    click_on "いいね"
    expect(page).to have_button "いいねを取り消す"
    expect(Like.count).to eq before_count + 1
  end

  scenario "いいねしたユーザーを表示する" do
    visit post_path(other_post.id)
    find('#user-tab').click
    expect(page).not_to have_content user.name
    click_on "いいね"
    find('#user-tab').click
    expect(page).to have_content user.name
  end

  scenario "検索した投稿を表示する" do
    visit posts_path
    expect(page).to have_content post.content
    expect(page).to have_content other_post.content
    fill_in "キーワードを入力して下さい", with: "ruby"
    click_on "検索"
    expect(page).to have_content post.content
    expect(page).not_to have_content other_post.content
    fill_in "キーワードを入力して下さい", with: "hello"
    click_on "検索"
    expect(page).not_to have_content post.content
    expect(page).to have_content other_post.content
    fill_in "キーワードを入力して下さい", with: "rails"
    click_on "検索"
    expect(page).to have_content post.content
    expect(page).not_to have_content other_post.content
  end

  scenario "投稿は降順に表示される" do
    visit posts_path
    within ".card", match: :first do
      expect(page).to have_content post.content
    end
  end
end
