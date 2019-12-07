require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "バリデーションのテスト" do
    it "コメントが有効" do
      comment = Comment.new(content: "a" * 10)
      comment.save
    end

    it "コメントは140文字以内" do
      comment = Comment.new(content: "a" * 141)
      comment.valid?
      expect(comment.errors[:content]).to include("は140文字以内で入力してください")
    end

    it "空コメントは無効" do
      comment = Comment.new(content: nil, user_id: 37)
      comment.valid?
      expect(comment.errors[:content]).to include("を入力してください")
    end
  end
end
