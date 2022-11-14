class Api::V1::ProductsController < ApplicationController
  # before_action :set_products, only: [:show]
  before_action :authenticate_user!
  def index
    product = Product.all.order(id: :asc)
    render json: product, status: 200
  end

  def show
    product = Product.find_by(id: params[:id])
    if product 
      render json: product, status:200
    else
      render json: {error: "Not Found"}, status: 404
    end 
  end 

  def create
    user = current_user
    if user.role == "admin"
      product = Product.new(product_params)
      if product.save
        render json: {product_details: product,
                      message: "Product saved successfully"},
              status: 200
      else
        render json: {error: product.errors.full_messages.join(',')}, status: 422
      end     
    else 
      render json: {message: "not authenticated"}, status: 401
    end
  end

  def update
    user = current_user
    if user.role == "admin"
      product = Product.find(params[:id])
      if product.update(product_params)
        render json: { product_details: product,
                      message: "Product updated successfully"},
                status: 200
      else
        render json: { error: product.errors.full_messages.join(',')}
      end 
    else 
      render json: {message: "not authenticated"}, status: 401
    end 
  end 

  def destroy
    user = current_user
    if user.role == "admin"
      product = Product.find(params[:id])
      if Order.where(product_id: product.id).present?
        render json: {message: "you can not destroy product"}
      else
        product.destroy
        render json: { message: "Product deleted successfully"},
                status: 200
        # else
        #   render json: { error: product.errors.full_messages.join(',')}
      end 
    else 
      render json: {message: "not authenticated"}, status: 401
    end 
  end 
    # redirect_to '/patients/new', :notice => "Your patient has been deleted"

  private 

  def product_params
    params.required(:product).permit([
      :name, :desc, :category, :price, :quantity
    ])
  end 
end
