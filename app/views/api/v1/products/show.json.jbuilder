json.extract! @product, :id, :productName, :amountAvailable, :cost_cents, :cost_currency
json.extract! @product.seller, :email
