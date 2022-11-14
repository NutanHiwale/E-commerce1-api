require 'rails_helper'

RSpec.describe Product, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it 'name must be required' do 
    product = Product.new(
      name: "",
      desc: "Pure Cotton",
      category: "clothes", 
      price: "1000",
      quantity: "2"
    )
    expect(product).to_not be_valid

    product.name = "Shirt"
    expect(product).to be_valid
  end 

  it 'price must be required' do 
    product = Product.new(
      name: "Shirt",
      desc: "Pure Cotton",
      category: "clothes", 
      price: "",
      quantity: "2"
    )
    expect(product).to_not be_valid 

    product.price = "1000"
    expect(product).to be_valid
  end 

  it 'quantity must be required' do
    product = Product.new(
      name: "Shirt",
      desc: "Pure Cotton",
      category: "clothes", 
      price: "1000",
      quantity: ""
    )
    expect(product).to_not be_valid

    product.quantity = "2"
    expect(product).to be_valid 
  end 
end
