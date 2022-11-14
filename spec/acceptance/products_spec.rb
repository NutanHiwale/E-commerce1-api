require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Products' do
  User.destroy_all
  let!(:user) {User.create!(email: "Jhon@gmail.com", password: 123456, password_confirmation: 123456, mobile_no: 1234567890, pincode: 411021, city: "pune", role: "admin")}
  let!(:product) {Product.create!(name: 'Shirt', desc: 'Pure cotton', category: 'clothes', price: '1000', quantity: '50')}

  post '/api/v1/products' do
    let(:user_id) {user.id}
    context 'creating a product' do
      example 'Success - create product successfully' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
        do_request({
          "product": {
            "name": "Shirt",
            "desc": "Pure Cotton",
            "category": "clothes",
            "price": "1000",
            "quantity": "100"
          }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["message"]).to eq("Product saved successfully")
        expect(response_status).to eq(200)
      end
      example 'Failure - Create product' do
        do_request({
          "product": {

            "name": "Shirt",
            "desc": "Pure Cotton",
            "category": "clothes",
            "price": "1000",
            "quantity": "100"
          }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end
    end
  end

  get '/api/v1/products' do
    context 'Product details' do
      example 'Success - Show all products' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
        do_request
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
      end 
      example 'Failure - Show all products' do
        do_request
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end
    end
  end
  
  get '/api/v1/products/:id' do
    let(:product_id) {product.id}
    let(:user_id) {user.id}
    context 'show product details' do
      example 'Success - Show particular product' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
        do_request({
            "id": product_id
        })
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
      end
      example 'Failure - Show particular product' do 
        do_request({
          "id": product_id
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end 
    end
  end 

  put '/api/v1/products/:id' do
    let(:product_id) {product.id}
    let(:user_id) {user.id} 
    context 'update products' do
      example 'Success - update product' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
        do_request({
          "id": product_id,
          "product": {
            "name": "Shirt updated",
            "desc": "Pure cotton",
            "category": "clothes",
            "price": "500",
            "quantity": "80"
           }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["message"]).to eq("Product updated successfully")
        expect(response_status).to eq(200)
      end 
      example 'Failure - update product' do 
        do_request({
          "id": product_id,
          "product": {
            "name": "Shirt updated",
            "desc": "Pure cotton",
            "category": "clothes",
            "price": "500",
            "quantity": "80"
           }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end  
    end
  end 

  delete '/api/v1/products/:id' do
    let(:product_id) {product.id}
    let(:user_id) {user.id} 
    context 'delete product' do
      example 'Success - delete product successfully' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"] 
        do_request({
          "id": product_id 
        })
        response_data = JSON.parse(response_body)
        expect(response_data["message"]).to eq("Product deleted successfully")
        expect(response_status).to eq(200)
      end 
      example 'Failure - delete product' do 
        do_request({
          "id": product_id 
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end
    end
  end 
end