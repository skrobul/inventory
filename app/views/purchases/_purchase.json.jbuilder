json.extract! purchase, :id, :retailer_id, :item_id, :quantity, :unit_cost, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
