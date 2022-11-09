class Api::V1::UsersController < Api::V1::BaseController
  def deposit
    if current_user.role == "buyer" && current_user.update(deposit_params)
      render json: current_user, status: :ok
    else
      render json: { data: current_user.errors.full_messages, status: "failed" }, status: :unprocessable_entity
    end
  end


  def deposit_params
    params.require(:user).permit(:deposit)
  end
end
