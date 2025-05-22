class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
def total_price
  product.price * quantity
end

validates :quantity, numericality: { greater_than: 0, message: "must be greater than zero" }
validates :product, presence: { message: "must be selected" }
end
