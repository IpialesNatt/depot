require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "add unique products" do
    cart = Cart.create
    book_one = products(:one)
    book_two = products(:two)

    cart.add_product(book_one)
    cart.add_product(book_two)

    assert_equal 2, cart.line_items.size
    assert_equal book_one.price + book_two.price, cart.total_price
  end

  test "add_duplicate_product" do
  cart = Cart.create
  ruby_book = products(:pragprog)

  # Primera adición
  assert_difference("cart.line_items.count", 1) do
    cart.add_product(ruby_book)
  end

  # Segunda adición (no debería crear nuevo line item)
  assert_no_difference("cart.line_items.count") do
    cart.add_product(ruby_book)
  end

  # Verificaciones finales
  assert_equal 1, cart.line_items.count
  assert_equal 2, cart.line_items.first.quantity
  assert_equal 2 * ruby_book.price, cart.total_price
end
end
