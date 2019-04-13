# frozen_string_literal: true

json.array! @allocations, partial: 'allocations/allocation', as: :allocation
