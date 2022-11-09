require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /index" do
    it "returns http success and the correct products" do
      # this will perform a GET request to the /health/index route
      user = User.create(email: "test@seller.com", password: "123456", role: "seller")
      Product.create(productName: "Mars",amountAvailable: 4, cost: 100, seller: user )
      get "/api/v1/products"

      json = JSON.parse(response.body).first

      # 'response' is a special object which contain HTTP response received after a request is sent
      # response.body is the body of the HTTP response, which here contain a JSON string
      expect(json["productName"]).to eq("Mars")
      expect(json["amountAvailable"]).to eq(4)
      expect(json["seller_id"]).to eq(user.id)
      # we can also check the http status of the response
      expect(response.status).to eq(200)
    end
  end
end

