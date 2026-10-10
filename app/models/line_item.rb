class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  def unit_price
    product&.price.to_f
  end

  def total_price
    unit_price * (quantity || 1).to_i
  end
end
