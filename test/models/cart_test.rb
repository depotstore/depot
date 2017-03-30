require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test 'total price and quantity of unique products' do
    cart = Cart.create
    cart.add_product(products(:ruby)).save!
    cart.add_product(products(:one)).save!

    assert_equal 2, cart.line_items.size
    assert_equal (products(:ruby).price + products(:one).price), cart.total_price
  end

  test 'total price and quantity of duplicate products' do
    cart = Cart.create
    cart.add_product(products(:ruby)).save!
    cart.add_product(products(:ruby)).save!

    assert_equal 1, cart.line_items.size
    assert_equal 2, cart.line_items[0].quantity
    assert_equal products(:ruby).price * 2, cart.total_price
  end

end
