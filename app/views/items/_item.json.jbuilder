# frozen_string_literal: true

json.extract! item, :id, :name, :category_id
json.url item_url(item, format: :json)
