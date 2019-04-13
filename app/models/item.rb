# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :category
  has_many :purchases
end
