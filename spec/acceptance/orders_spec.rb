require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Orders' do
  # Order.destroy_all
  # Product.destroy_all
  # User.destroy_all
  # current_user = User.create!(email: 's@gmail.com', password: '123456',password_confirmation: '123456', mobile_no: '9087654321', city: 'pune', pincode: '411021') 
  # current_product = Product.create!(name: 'Shirt', desc: 'Pure cotton', category: 'clothes', price: '1000', quantity: '50')
  # current_order = Order.create!(name: 'Shirt', quantity: '2', price: '1000', user_id: current_user.id, product_id: current_product.id)
  let!(:user) {User.create!(email: 'l@gmail.com', password: '123456',password_confirmation: '123456', mobile_no: '9087654321', city: 'pune', pincode: '411021')}
  let!(:product) {Product.create!(name: 'Shirt', desc: 'Pure cotton', category: 'clothes', price: '1000', quantity: '50')}
  let!(:order) {Order.create!(name: 'Shirt', quantity: '2', price: '1000', user_id: user.id, product_id: product.id)}

  post '/api/v1/orders' do
    let(:product_id) {product.id}
    let(:user_id) {user.id}
    context 'creating a order' do
      example 'Failure - Creating a order' do
        do_request({
          "order": {
            "name": 'Shirt',
            "quantity": '2',
            "price": '1000',
            "product_id": product_id,
            "user_id": user_id
          }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
        # 401 => Unauthorized status 
      end
      example 'Success - create order successfully' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
        do_request({
          "order": {
            "name": 'Shirt',
            "quantity": '2',
            "price": '1000',
            "product_id": product_id,
            "user_id": user_id
          }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["message"]).to eq("Order saved successfully")
        expect(response_status).to eq(200)
      end 
    end 
  end 

  get '/api/v1/orders' do
    context 'Order details' do 
      let(:id) {product.id}
      let(:id) {user.id}
      example 'Success - Show orders' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
        do_request
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
      end 
      example 'Failure - Show orders' do
        do_request({
          "order": {
            "name": 'Shirt',
            "quantity": '2',
            "price": '1000'
            # "product_id": current_product.id,
            # "user_id": current_user.id
          }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end 
    end 
  end

  put '/api/v1/orders/:id' do 
    context 'update order' do
      let(:id) {product.id}
      let(:id) {user.id}
      let(:id) {order.id}
      example 'Success - update order successfully' do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"] 
        do_request({
          # "id": current_order.id,
          "order": {
            "name": 'Shirt updated',
            "quantity": '2',
            "price": '1000'
            # "product_id": current_product.id,
            # "user_id": current_user.id
          }
        })
        response_data = JSON.parse(response_body)
        expect(response_data["message"]).to eq("Order updated successfully!")
        expect(response_status).to eq(200)
      end
      example 'Failure - update order' do 
        do_request({
          # "id": current_order.id, 
          "order": {
            "name": 'Shirt updated',
            "quantity": '2',
            "price": '1000',
            # "product_id": current_product.id,
            # "user_id": current_user.id
          }
        }) 
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end 
    end       
  end 

  delete '/api/v1/orders/:id' do 
    context 'delete order' do
      let(:id) {product.id}
      let(:id) {user.id}
      let(:id) {order.id}
      example 'Success - delete order successfully' do
        auth_headers = user.create_new_auth_token
        header "access_token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
        do_request({
          # "id": current_order.id
        })
        response_data = JSON.parse(response_body)
        expect(response_data["message"]).to eq("Order deleted successfully")
        expect(response_status).to eq(200)
      end
      example 'Failure - delete order' do 
        do_request({
          # "id": current_order.id 
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end 
    end 
  end 
end 


  # get '/api/v1/orders/:id' do
  #   context 'Order details' do
  #     example 'Failure - Show particular orders' do
  #       do_request({
  #         "order": {
  #           "name": 'Shirt',
  #           "quantity": '2',
  #           "price": '1000',
  #           "product_id": current_product,
  #           "user_id": current_user.id
  #         }
  #       })
  #       response_data = JSON.parse(response_body)
  #       expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
  #       expect(response_status).to eq(401)
  #     end 
  #   end
  # end
