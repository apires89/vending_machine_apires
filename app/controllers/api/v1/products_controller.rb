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

  private

  def product_params
    params.require(:product).permit(:productName, :cost, :amountAvailable, :seller_id)
  end

  def set_product
    @product = current_user.products.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
      render json: error.message, status: :unauthorized
  end
end
