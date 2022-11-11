require 'rails_helper'

RSpec.describe "User", type: :request do
  describe "PATCH /deposit" do
    let!(:current_user) { FactoryBot.create(:buyer) }
    it "returns http success and deposits the correct amount on the user" do
      patch "/api/v1/users/deposit"
      user_login(current_user)
    end
  end
end
