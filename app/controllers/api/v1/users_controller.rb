class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    user = current_user
    if user.role == "admin"

      user = User.all.order(id: :asc)
      render json: user
    else 
      render json: {message: "not authenticated"}, status: 401
    end 
  end 

  def show 
    user = current_user
    if user.role == "admin"
      # render json: user
      
      user = User.find_by(id: params[:id])
      if user 
        render json: {message: "User details are as follows",
                      user_details: user},
                      status: 200
      else
        render json:{error: "Not Found"}, status: 404
      end 
    else 
      render json: {message: "not authenticated"}, status: 401
    end 
  end 

  def create 
    user = User.new(user_params)
    if user.save
      render json: {user_details: user,
                    message: "User created successfully"},
              status: 200
    else
      render json: {error: user.errors.full_messages.join(',')}, status: 422
    end
  end 

  def update
    a = current_user
    begin
      user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: "No such user!"},status: 200
    else
      if(user.id != a.id) 
        render json: {message: "User not authenticated!"}, status: 401
      else

        user.update(user_params)
        render json: {user_details: user,
                    message: "User updated successfully"},
              status: 200
        # else
        #   render json: {error: user.errors.full_messages.join(',')}
      end 
    end
  end

  # def destroy
  #   user = User.find(params[:id])
  #   # if user.id == user.find(user_params[:id])
  #   # user.id == current_user.id
  #   if user.destroy
  #     render json: { message: "User deleted successfully"},
  #             status: 200
  #   else
  #     render json: { error: user.errors.full_messages.join(',')}
  #     # render json: {error: "you can not delete another user's account"}
  #   end 
  # end 

  def destroy
    a = current_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: "No such user!"},status: 200
    else

      # if user.id == user.find(user_params[:id])
      # user.id == current_user.id
      if(@user.id != a.id) 
        render json: {message: "User not authenticated!"}, status: 401
      else
        # user.destroy!(user_params)
        @user.destroy
        render json: { message: "User deleted successfully"},
                status: 200
        # else
        # render json: { error: user.errors.full_messages.join(',')}
      end 
    end 
  end 

  private

  def user_params 
    params.require(:user).permit([
      :first_name, :last_name, :email, :address, :pincode, :city, :mobile_no, :role 
    ])
  end
end
