module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def user_login(user)

    secret = ENV["DEVISE_JWT_SECRET_KEY"]

    encoding = 'HS512'

    request.headers["Authorization"] =
      JWT.encode({ user_id: user.id }, secret, encoding)
  end

end
