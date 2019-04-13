json.extract! purchase, :id, :retailer_id, :item_id, :quantity, :unit_cost
json.url purchase_url(purchase, format: :json)
