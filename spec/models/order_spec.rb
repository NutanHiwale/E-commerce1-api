require 'rails_helper'

RSpec.describe Order, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  Order.destroy_all
  User.destroy_all
  current_user = User.create!(email: 's@gmail.com', password: '123456',password_confirmation: '123456', mobile_no: '9087654321', city: 'pune', pincode: '411021', role: 'admin')
  Product.destroy_all
  current_product = Product.first_or_create!(name: 'Shirt', desc: 'Pure cotton', category: 'clothes', price: '1000', quantity: '50')
 
  it 'name must be required' do
    order = Order.new(
      name: '',
      quantity: '2',
      price: '1000',
      product_id: current_product.id,
      user_id: current_user.id
    )
    expect(order).to_not be_valid

    order.name = 'Shirt'
    expect(order).to be_valid
  end

  it 'quantity must be required' do
    order = Order.new(
      name: 'Shirt',
      quantity: '',
      price: '1000',
      product_id: current_product.id,
      user_id: current_user.id
    )
    expect(order).to_not be_valid

    order.quantity = '2'
    expect(order).to be_valid
  end 
  
  it 'price must be required' do
    order = Order.new(
      name: 'Jeans',
      quantity: '3',
      price: '',
      product_id: current_product.id,
      user_id: current_user.id
    )
    expect(order).to_not be_valid

    order.price = '2000'
    expect(order).to be_valid
  end
end
