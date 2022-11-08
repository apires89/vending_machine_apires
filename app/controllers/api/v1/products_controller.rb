class Api::V1::ProductsController < Api::V1::BaseController
  before_action :set_product, only: [ :show, :update, :destroy ]
  def index
    @products = policy_scope(Product)
  end

  def show
  end

  def update
    if @product.update(product_params)
      render :show
    else
      render_error
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :address)
  end

  def render_error
    render json: { errors: @product.errors.full_messages },
      status: :unprocessable_entity
  end

  private

  def set_product
    @product = current_user.products.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
      render json: error.message, status: :unauthorized
    authorize @product  # For Pundit
  end
end
