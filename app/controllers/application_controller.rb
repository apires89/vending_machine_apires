class ApplicationController < ActionController::API
  attr_accessor :current_user
  before_action :configure_permitted_parameters, if: :devise_controller?



    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found
   def authenticate_user!
      return response_401 if request.headers["Authorization"].blank?

      secret = ENV['DEVISE_JWT_SECRET_KEY']

      encoding = 'HS512'

      token = request.headers["Authorization"].split(" ")[1]

      user_id = begin
                  JWT.decode(token, secret, true, { algorithm:   encoding })[0]["user_id"]
                rescue JWT::ExpiredSignature, JWT::VerificationError
                  return response_401
                end
      @current_user = User.find(user_id)
    end
    def rescue_from_not_found
      nil
    end
    def response_401
      head(:unauthorized)
    end
    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[role])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[role])
    end
end
