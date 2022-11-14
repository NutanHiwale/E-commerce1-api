class Product < ApplicationRecord
  validates :name, presence: true 
  validates :price, presence: true 
  validates :quantity, presence: true 
end
