class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  has_many :products
  monetize :deposit_cents
  validates :role, inclusion: { in: %w(seller buyer),
    message: "%{value} is not a valid role" }

  def jwt_payload
    super
  end
end

