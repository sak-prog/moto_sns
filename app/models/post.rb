class Post < ApplicationRecord
  acts_as_taggable

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  mount_uploader :image, ImageUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end
end
