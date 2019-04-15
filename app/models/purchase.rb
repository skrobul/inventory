# frozen_string_literal: true

class Purchase < ApplicationRecord
  belongs_to :retailer
  belongs_to :item
  has_many :allocations

  scope :orig_available_by_item, lambda { |item_id|
    find_by_sql(
      ['SELECT *
        FROM (
          SELECT purchases.id, purchases.quantity - COALESCE(SUM(allocations.quantity), 0) AS available
          FROM purchases
          LEFT JOIN allocations ON purchases.id = allocations.purchase_id
          WHERE item_id = ?
          GROUP BY purchases.id
          ORDER by purchases.date
        ) AS open_purchases
        WHERE available > 0',
       item_id]
    ).map { |purchase| Purchase.find(purchase.id) }
  }

  scope :available_by_item_using_single_query, lambda { |item_id|

    find_by_sql(
      ['
          SELECT purchases.id, purchases.quantity - COALESCE(SUM(allocations.quantity), 0) AS available
          FROM purchases
          LEFT JOIN allocations ON purchases.id = allocations.purchase_id
          WHERE item_id = ?
          GROUP BY purchases.id
          HAVING purchases.quantity - COALESCE(SUM(allocations.quantity), 0) > 0
          ORDER by purchases.date
',
       item_id]
    ).map { |purchase| Purchase.find(purchase.id) }
  }

  scope :available_by_item, lambda { |item_id|
    where(item_id: item_id)
      .left_joins(:allocations)
      .group(:id)
      .having('purchases.quantity - COALESCE(SUM(allocations.quantity), 0) > 0')
      .order(:date)
  }

  scope :available_by_item_possibly_simpler, lambda { |item_id|
    where(item_id: item_id)
      .joins(:allocations)
      .group(:id)
      .having('purchases.quantity - SUM(allocations.quantity) > 0')
      .order(:date)
  }

  def total_cost
    (unit_cost || 0) * quantity.to_i
  end

  def used
    allocations.sum(:quantity)
  end

  def available
    quantity - used
  end
end
