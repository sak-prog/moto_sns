class Manufacturer < ApplicationRecord
  has_many :manufacturer_users
  has_many :users, through: :manufacturer_users, dependent: :destroy
end
