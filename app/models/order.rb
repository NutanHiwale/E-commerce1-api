class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates :name, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
end
