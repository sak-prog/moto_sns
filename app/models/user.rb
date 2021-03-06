class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name:  'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :manufacturer_users, dependent: :destroy
  has_many :manufacturers, through: :manufacturer_users
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :introduce, length: { maximum: 160 }
  validates :motorcycle, length: { maximum: 100 }

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Post.includes(:user).where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def self.find_for_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = "facebook user"
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
