# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :category
  has_many :purchases

  ItemBreakdown = Struct.new(:unit_cost, :quantity) do
    def value
      (unit_cost * quantity)
    end
  end

  def available
    Purchase.available_by_item(id).inject(0) do |sum, purchase|
      sum + purchase.available
    end
  end

  def available_value
    Purchase.available_by_item(id).inject(0) do |sum, purchase|
      sum + purchase.unit_cost * purchase.available
    end
  end

  def available_breakdown
    Purchase.available_by_item(id).map do |purchase|
      ItemBreakdown.new(purchase.unit_cost, purchase.available)
    end
  end
end
