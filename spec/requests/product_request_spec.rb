require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /index" do
    before do
      #DB clean
      Product.destroy_all
      User.destroy_all
      ##
      FactoryBot.create_list(:seller, 5)
      FactoryBot.create_list(:product, 5)
      get "/api/v1/products"
    end
    it "returns all products" do
      expect(json.size).to eq(5)
    end
    it "returns stauts code 200" do
      expect(response.status).to eq(200)
    end
  end
   describe "POST /buy" do
    let!(:my_seller) { FactoryBot.create(:seller) }
    let!(:current_user) { FactoryBot.create(:buyer) }
    let!(:my_product) { FactoryBot.create(:buy_product) }
    it 'returns not enough money if there is not enough money' do
      post "/api/v1/products/#{my_product.id}/buy", params: { product: { amount: 1 }}
      expect(json[1]).to eq("Not enough money to buy") if my_product.cost > current_user.deposit
    end
    it 'returns not logged in if user not logged in.' do
      post "/api/v1/products/#{my_product.id}/buy", params: { product: { amount: 1 }}
      expect(json["message"]).to eq("Not logged in")
    end

    it 'returns bought!' do
      #TODO
      #post "/api/v1/products/#{my_product.id}/buy", params: { product: { amount: 1 }}
      #user_login(current_user)
    end
    it "returns stauts code 200" do
      expect(response.status).to eq(200)
    end
  end
end

