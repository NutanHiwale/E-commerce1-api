class Api::V1::OrdersController < ApplicationController
  # before_action :set_order, only: [:show]
  before_action :authenticate_user!
  
  def index
    user = current_user
    if user.role == "admin"
      order = Order.all
    else
      order = Order.where(user_id: current_user.id)
    end
    if order
      render json: order, status: 200
    else
      render json: {error: "Not Found"}, status: 404
    end
  end

  def create
    order = Order.new(order_params)
    product_quantity = Product.find(order_params[:product_id]).quantity.to_i
    if order.quantity > product_quantity
      render json: {message: "you can not order"}
    elsif order.save
      @product = Product.find(order_params[:product_id])
      @product.quantity = @product.quantity.to_i - order.quantity
      @product.save!
      render json: {order_details: order,
                    message: "Order saved successfully"},
              status: 200
    else 
      render json: {error: order.errors.full_messages.join(',')}, status: 422
    end 
  end 

  def destroy
    # order = Order.new(order_params)
    order = Order.find(params[:id])
    if order.present?
      @product = Product.find(order.product_id)
      @product.quantity = @product.quantity.to_i + order.quantity
      @product.save!
      order.destroy
      render json: { message: "Order deleted successfully"},
              status: 200
    else
      render json: { error: order.errors.full_messages.join(',')}
    end 
  end 

  def update
    user = current_user
    begin
      order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: "No such order!"},status: 200
    else
      if(order.user_id != user.id)
        render json: {message: "User not authenticated!"}, status: 401
      else
        order.update!(order_params)
        # render json: order.status, status: 200
        render json: {message: "Order updated successfully!"}, status: 200
      end
    end
  end

 # def update
  #   order = Order.find(params[:id])
  #   if Order.update(order_params)
  #     render json: { order_details: order,
  #                    message: "Order updated successfully"},
  #             status: 200
  #   else
  #     render json: { error: order.errors.full_messages.join(',')}
  #   end 
  # end 

  private 

  def order_params
    params.required(:order).permit([
      :name, :quantity, :price, :user_id, :order_id, :product_id
    ])
  end 
end
