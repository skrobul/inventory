# frozen_string_literal: true

json.extract! retailer, :id, :name
json.url retailer_url(retailer, format: :json)
