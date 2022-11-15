require 'rails_helper'

RSpec.describe User, type: :model do
  # current_user = User.first_or_create!(first_name: 'nutan', last_name: 'hiwale', email: 'nutan@gmail.com', password: '123456', address: 'Bavdhan', pincode: '411021', city: 'Pune', mobile_no: '9088776655')

  it 'email must be required' do 
    user = User.new(
      first_name: "nutan",
      last_name: 'hiwale',
      email: '',
      password: '123456',
      address: 'Bavdhan', 
      pincode: '411021', 
      city: 'Pune', 
      mobile_no: '9088776655'
    )
    expect(user).to_not be_valid 

    user.email = "nutan@gmail.com"
    expect(user).to be_valid
  end 

  it 'mobile number must be required' do 
    user = User.new(
      first_name: "nutan",
      last_name: 'hiwale',
      email: 'nutan@gmail.com',
      password: '123456',
      address: 'Bavdhan', 
      pincode: '411021', 
      city: 'Pune', 
      mobile_no: ''
    )
    expect(user).to_not be_valid

    user.mobile_no = "9088776654"
    expect(user).to be_valid
  end 

  it 'pincode must be required' do
    user = User.new(
      first_name: "nutan",
      last_name: 'hiwale',
      email: 'nutan@gmail.com',
      password: '123456',
      address: 'Bavdhan', 
      pincode: '', 
      city: 'Pune', 
      mobile_no: '9088776543'
    )
    expect(user).to_not be_valid

    user.pincode = "411021"
    expect(user).to be_valid
  end 

  it 'city must be required' do
    user = User.new(
      first_name: "nutan",
      last_name: 'hiwale',
      email: 'nutan@gmail.com',
      password: '123456',
      address: 'Bavdhan', 
      pincode: '411021', 
      city: '', 
      mobile_no: '9088776543'
    )
    expect(user).to_not be_valid

    user.city = "pune"
    expect(user).to be_valid
  end 
end 