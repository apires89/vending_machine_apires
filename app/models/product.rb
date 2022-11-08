class Product < ApplicationRecord
  monetize :cost_cents
  belongs_to :seller, class_name: "User"
end
