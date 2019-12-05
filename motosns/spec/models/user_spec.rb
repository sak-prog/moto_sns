require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    it "名前＋メールアドレス＋パスワードがあれば有効" do
      expect(build(:user)).to be_valid
    end

    it "名前がなければ無効" do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "メールアドレスがなければ無効" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "重複したメールアドレスは無効" do
      user = create(:user, email: "aaron@example.com")
      user = build(:user, email: "aaron@example.com")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it "パスワードがなければ無効" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "名前は50文字以内" do
      user = build(:user, name: 'a' * 51) 
      user.valid?
      expect(user.errors[:name]).to include("は50文字以内で入力してください")
    end

    it "自己紹介は160文字以内" do
      user = build(:user, introduce: 'a' * 161) 
      user.valid?
      expect(user.errors[:introduce]).to include("は160文字以内で入力してください")
    end

    it "車種は100文字以内" do
      user = build(:user, motorcycle: 'a' * 101) 
      user.valid?
      expect(user.errors[:motorcycle]).to include("は100文字以内で入力してください")
    end
  end
end
