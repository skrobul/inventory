# frozen_string_literal: true

json.extract! allocation, :id, :date, :item_id
json.url allocation_url(allocation, format: :json)
