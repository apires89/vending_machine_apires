class ApplicationController < ActionController::API
  attr_accessor :current_user

    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found
   def authenticate_user!

      return send_401 if request.headers["Authorization"].blank?

      secret = ENV['DEVISE_JWT_SECRET_KEY']

      encoding = 'HS512'

      token = request.headers["Authorization"].split(" ")[1]

      user_id = begin
                  JWT.decode(token, secret, true, { algorithm:   encoding })[0]["user_id"]
                rescue JWT::ExpiredSignature, JWT::VerificationError
                  return send_401
                end
      @current_user = User.find(user_id)
    end
    def rescue_from_not_found
      nil
    end
    def response_401
      head(:unauthorized)
    end
end
