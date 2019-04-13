# frozen_string_literal: true

json.array! @retailers, partial: 'retailers/retailer', as: :retailer
