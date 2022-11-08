class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist
  has_many :products
  monetize :deposit_cents
  validates :role, inclusion: { in: %w(seller buyer),
    message: "%{value} is not a valid role" }
end
