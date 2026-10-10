class Order < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: proc { |attrs| attrs['product_id'].blank? }

  before_validation :calculate_total, if: -> { line_items.present? }

  def calculate_total
    computed = line_items.sum(&:total_price)
    self.total = computed if computed > 0 || total.blank?
  end
end
