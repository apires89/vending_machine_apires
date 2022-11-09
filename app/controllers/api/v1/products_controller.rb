class Api::V1::ProductsController < Api::V1::BaseController
  before_action :set_product, only: [ :show, :update, :destroy ]
  def index
    @products = Product.all
  end

  def show
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
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: { data: @product.errors.full_messages, status: "failed" }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: { data: 'product deleted successfully', status: 'sucess' }, status: :ok
    else
      render json: { data: 'Something went wrong', status: 'failed' }
    end
  end

  def buy
    #accepts productId and amount
    check_input_for_purchase
    #user with buyuer role can buy a product
    check_role_and_deposit
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
    @product = current_user.products.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
      render json: error.message, status: :unauthorized
  end

  def check_input_for_purchase
    @amount = params["product"]["amount"]
    @product = Product.find(params[:id])
  end

  def check_role_and_deposit
    if current_user.role == "buyer"
      @deposit = current_user.deposit
    else
      render json: { message: "Not a customer, or something went wrong.", status: "failed" }, status: :unprocessable_entity
    end
  end

  def calculate_output
    #remove one product from DB
    @product.update(amountAvailable: @product.amountAvailable - 1)
    #update user deposit and spent
    spent = @product.cost
    current_user.update(deposit: @deposit - @product.cost)
    change = @deposit - @product.cost
    #json with info
    render json: { message: "Purchase Completed!",data: {
      spent: spent,
      productName: @product.productName,
      change: change
    }, status: "success" }, status: :ok
  end
end
