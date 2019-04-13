# frozen_string_literal: true

json.extract! purchase, :id, :date, :retailer_id, :item_id, :quantity, :unit_cost
json.url purchase_url(purchase, format: :json)
