role = ["seller", "buyer"]
FactoryBot.define do
  factory :seller, class: "User" do
    email { Faker::Internet.email }
    password { "123456" }
    role { "seller" }
    deposit { rand(1...5) }
  end
  factory :buyer, class: "User" do
    email { Faker::Internet.email }
    password { "123456" }
    role { "buyer" }
    deposit { rand(1...5) }
  end
  name = ["Mars", "KitKat","Toblerone","Ferrero","M&M","Smarties","Dime","Nutella","Lays","Coca-Cola"]
  factory :product do
    amountAvailable { rand(2..5) }
    cost { rand(1...2) }
    productName { name.delete(name.sample) }
    seller { User.find_by(role: "seller")}
  end
  factory :buy_product, class: "Product" do
    amountAvailable { rand(2..5) }
    cost { rand(1...2) }
    productName { Faker::Food.dish }
    seller { User.find_by(role: "seller")}
  end
end
