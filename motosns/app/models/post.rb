class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
