class Cart < ApplicationRecord
    # This model represents a shopping cart in the application.
    has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product.id)
      current_item.price = product.price
    end
    current_item.save!
    current_item
  end

  def total_price
    line_items.sum { |item| item.total_price }
  end
end
