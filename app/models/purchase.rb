class Purchase < ApplicationRecord
  belongs_to :retailer
  belongs_to :item

  def total_cost
    (unit_cost || 0) * quantity.to_i
  end
end
