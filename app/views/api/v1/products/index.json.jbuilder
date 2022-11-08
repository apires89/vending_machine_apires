json.array! @products do |product|
  json.extract! product, :id, :productName, :amountAvailable, :cost_cents
end
