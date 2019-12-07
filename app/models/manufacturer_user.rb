class ManufacturerUser < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :user
end
