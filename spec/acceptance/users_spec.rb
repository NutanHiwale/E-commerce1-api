require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do   
  let!(:user) {User.create!(email: "nutan@gmail.com", password: 123456, password_confirmation: 123456, mobile_no: 1234567890, pincode: 411021, city: "pune", role: "admin")}

  post '/auth' do
    context 'creating a user' do
      example 'Success - Create user successfully' do
        do_request({
          
            "first_name": "Nutan",
            "last_name": "H",
            "email": "nutanh@gmail.com",
            "password": "123456",
            "address": "Bavdhan",
            "pincode": "411021",
            "city": "Pune",
            "mobile_no": "9022889767",
            "role": "admin"
          
        })
        response_data = JSON.parse(response_body)
        expect(response_data["status"]).to eq("success")
        expect(response_status).to eq(200)
      end

      example 'Failure - Create user with same email' do
        do_request({

            "first_name": "Nutan",
            "last_name": "Hiwale",
            "email": User.last.email,
            "password": "123456",
            "address": "Bavdhan",
            "pincode": "411021",
            "city": "Pune",
            "mobile_no": "9022889767"

        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]["full_messages"][0]).to eq("Email has already been taken") 
        expect(response_status).to eq(422)
      end 
    end 
  end 

  get '/api/v1/users' do 
    context 'user details' do
      example 'Failure - show all users' do
        do_request
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end 
    end 

    context 'user details' do
      before do
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
      end
      example 'Success - show all users' do 
          do_request
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
      end 
    end 
  end
  
  get '/api/v1/users/:id' do 
    context 'particular users detail' do 
      example 'Failure - show particular user' do
        do_request
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end 
    end 

    context 'particular users detail' do 
      before do 
        auth_headers = user.create_new_auth_token
        header "access-token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
      end 
      let(:id) {user.id}
      example 'Success - show particular user' do 
        do_request({
          "id": id
        })
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
      end 
    end 
  end 

  post '/auth/sign_in' do
    context 'sign_in' do
      example 'Success-sign_in' do
        do_request({
          "email": user.email,
          "password": user.password,
          "confirm_password": user.password
        })
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
      end 

      example 'Failure-sign_in' do 
        do_request({
          "email": "jhon1234@gmail.com",
          "password": "123456",
          "confirm_password": "123456"
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["Invalid login credentials. Please try again."])
        expect(response_data["success"]).to eq(false)
        expect(response_status).to eq(401)
      end 
    end 
  end 

  put '/api/v1/users/:id' do 
    context 'update user' do 
      let(:id) {user.id} 
      example 'Failure - update user' do
        do_request({
  
          "first_name": "Nutan",
          "last_name": "H",
          "email": "nutanh@gmail.com",
          "password": "123456",
          "address": "Bavdhan",
          "pincode": "411021",
          "city": "Pune",
          "mobile_no": "9022889767"
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
        expect(response_status).to eq(401)
      end 
    end 

    context 'update user' do 
      before do 
        auth_headers = user.create_new_auth_token
        header "access_token", auth_headers["access-token"]
        header "client", auth_headers["client"]
        header "uid", auth_headers["uid"]
      end 

      let(:id) {user.id}
      example 'Success - update user' do
        do_request({
        "id": id,
        "user": {
            "first_name": "Nutan",
            "last_name": "H",
            "email": "nutanh@gmail.com",
            "password": "123456",
            "address": "Bavdhan",
            "pincode": "411021",
            "city": "Pune",
            "mobile_no": "9022889767"
          }
        }) 
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
      end 
    end 
  end

  delete '/api/v1/users/:id' do
    let(:id) {user.id}
    context 'delete user' do
      example 'Failure - delete a user' do
        do_request({
          "id": id
        })
        response_data = JSON.parse(response_body)
        expect(response_data["errors"]).to eq(["You need to sign in or sign up before continuing."])
      end
    end
    # context 'delete user' do
    #   let!(:user1) {User.create!(email: "nutaaan@gmail.com", password: 123456, password_confirmation: 123456, mobile_no: 1234567890, pincode: 411021, city: "pune", role: "admin")}
    #   before do
    #     auth_headers = user1.create_new_auth_token
    #     header "access_token", auth_headers["access-token"]
    #     header "client", auth_headers["client"]
    #     header "uid", auth_headers["uid"] 
    #   end
    #   # let!(:user1) {User.create!(email: "nutaaan@gmail.com", password: 123456, password_confirmation: 123456, mobile_no: 1234567890, pincode: 411021, city: "pune", role: "admin")}
    #   let(:user_id) {user1.id} 
    #   example 'Success - delete a user successfully' do 
    #     do_request({
    #       "id": user_id
    #     })
    #     response_data = JSON.parse(response_body)
    #     expect(response_data["message"]).to eq("User deleted successfully")
    #   end
    # end 
  end 
end 





# RSpec.describe 'UsersController', type: :controller do
#   let!(:user) { User.create(first_name: 'Nutan', last_name: 'Hiwale', email: 'nutan@gmail.com', password: '123456', address: 'Bavdhan', pincode: '411021', city: 'pune', mobile_no: '8907654321') }

#   let(:auth_header) { user.create_new_auth_token }
#   request.headers.merge!(user.create_new_auth_token) if sign_in(user)

#   describe 'to create user' do
#     context 'when user is logged in' do
#       request.headers.merge! auth_header
#       it 'returns http success' do
#         post :create
#         json_response = JSON.parse(response.body)
#         expect(response).to have_http_status(:success)
#         expect(json_response['data'].count).to eq 1
#       end 
#     end 
#   end 




# https://github.com/Addy-tea-ya-official/EasyRides-web/blob/master/spec/acceptance/drivers_spec.rb