require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "バリデーションのテスト" do
    it "投稿が有効" do
      post = Post.new(content: "a" * 10)
      post.save
    end

    it "contentが無い投稿は無効" do
      post = Post.new(content: nil)
      post.valid?
      expect(post.errors[:content]).to include("を入力してください")
    end

    it "文字数は140文字以内" do
      post = Post.new(content: "a" * 141, user_id: 1)
      post.valid?
      expect(post.errors[:content]).to include("は140文字以内で入力してください")
    end
  end
end
