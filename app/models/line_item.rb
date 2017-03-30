class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity #price doesn't pass tests for controllers
  end

  def self.decrement(line_item)
    if line_item.quantity > 0
        line_item.quantity -= 1
        line_item.save
    end
    line_item.destroy if line_item.quantity <= 0
    line_item
  end
end
