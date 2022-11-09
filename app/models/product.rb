class Product < ApplicationRecord
  monetize :cost_cents
  belongs_to :seller, class_name: "User"
  after_create :change_user_to_seller


  def change_user_to_seller
    self.seller.update(role: "seller")
  end
end
