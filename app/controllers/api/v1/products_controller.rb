class Api::V1::ProductsController < Api::V1::BaseController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :set_product, only: [ :show, :update, :destroy ]
  before_action :check_login, except: [:index,:show]

  def index
    @products = Product.all
    render json: @products, status: :ok
  end

  def show
    render json: @product, status: :ok
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      render json: @product, status: :ok
    else
      render json: { data: @product.errors.full_messages, status: "failed" }, status: :unprocessable_entity
    end
  end

  def update
    if @product.seller == current_user && @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: { data: @product.errors.full_messages, status: "failed" }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.seller == current_user && @product.destroy
      render json: { data: 'product deleted successfully', status: 'sucess' }, status: :ok
    else
      render json: { data: 'Something went wrong', status: 'failed' }
    end
  end

  def buy
    unless user_signed_in?
        render json: { message: "Not logged in", status: "failed" }, status: :unprocessable_entity
        return
    end
    #accepts productId and amount
    check_input_for_purchase
    #user with buyuer role can buy a product
    if current_user.role == "buyer"
      @deposit = current_user.deposit
    else
      render json: { message: "Not a customer, or something went wrong.", status: "failed" }, status: :unprocessable_entity
      return
    end
    #with deposited money
    if @product.cost > @deposit
      render json: { message: "Not enough money to buy #{@product.productName}", status: "failed" }, status: :unprocessable_entity
    else
      #api should return total spent, product purchased and change
      calculate_output
    end
  end



  private

  def product_params
    params.require(:product).permit(:productName, :cost, :amountAvailable, :seller_id)
  end

  def set_product
    @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
      render json: error.message, status: :unauthorized
  end

  def check_input_for_purchase
    @amount = params["product"]["amount"]
    @product = Product.find(params[:id])
  end


  def calculate_output
    #remove one product from DB
    @product.update(amountAvailable: @product.amountAvailable - 1)
    #update user deposit and spent
    spent = @product.cost
    current_user.update(deposit: @deposit - @product.cost)
    change = @deposit - @product.cost
    valid_change = calculate_change(change)


    #json with info
    render json: { message: "Purchase Completed!",data: {
      spent: spent,
      productName: @product.productName,
      change: valid_change
    }, status: "success" }, status: :ok
  end

  def calculate_change(change)
    valid_change = [[10,0],[20,0],[50,0],[100,0]].reverse
    change_value = Money.new(0)
      if change.to_s.chars.last == "5"
        valid_change.append = [5,1]
        change_value = Money.new(5)
      end
      valid_change.map do |number|
        if change_value < change && change > Money.new(number[0])
          change_value = change - Money.new(number[0])
          number[1] += 1
        end
      end
    valid_change.append = [5,0] if valid_change.last[0] == 10
    valid_change
  end


  def check_login
    unless user_signed_in?
      render json: { message: "Not logged in", status: "failed" }, status: :unprocessable_entity
      return
    end
  end
end
