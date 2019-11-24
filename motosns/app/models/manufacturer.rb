class Manufacturer < ApplicationRecord
  has_many :manufacturer_users, dependent: :destroy
  has_many :users, through: :manufacturer_users
end
