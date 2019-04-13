class Allocation < ApplicationRecord
  belongs_to :purchase

  AllocationResult = Struct.new(:success?, :allocations, :error_message)

  def self.allocate_items(params)
    required_quantity = Integer(params.delete(:quantity))
    available_purchases = Purchase.available_by_item(params.delete(:item_id))
    total_available_items = available_purchases.inject(0) do |sum, purchase|
      sum + purchase.available
    end

    if required_quantity <= total_available_items
      allocations = []
      while required_quantity > 0
        purchase = available_purchases.shift
        purchase_max_allocation = purchase&.available || 0
        if required_quantity > purchase_max_allocation
          params[:quantity] = purchase_max_allocation
          params[:purchase_id] = purchase.id
          required_quantity -= purchase_max_allocation
        else
          params[:quantity] = required_quantity
          params[:purchase_id] = purchase.id
          required_quantity -= required_quantity
        end
        allocations << Allocation.new(params)
      end
      AllocationResult.new(true, allocations, nil)
    else
      AllocationResult.new(false, [], "There weren't enough purchases to complete the allocation.")
    end
  end
end
