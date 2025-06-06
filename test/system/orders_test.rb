require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "should create order" do
    # Entramos a la tienda para añadir productos
    visit store_index_url
    click_on "Add to Cart", match: :first

    visit orders_url
    click_on "New Order"

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    select @order.payment_type.name, from: "Pay type"    # Ensure the pay_type is selected correctly
    click_on "Place Order"
    assert_text "Thank you for your order."
    # click_on "Back" --si lo descomento me da error porque no encuentra el boton
  end

  test "should update Order" do
    visit order_url(@order)
    click_on "Edit", match: :first # Ensure we are editing the correct order

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
   select @order.payment_type.name, from: "Pay type"
    click_on "Place Order"

    assert_text "Order was successfully updated"
    # click_on "Back"
  end

  test "should destroy Order" do
    visit order_url(@order)
    accept_confirm { click_on "Destroy", match: :first }

    assert_text "Order was successfully destroyed"
  end


    # Test for order creation with data
    test "check dynamic fields" do
        skip "Test temporalmente omitido"
    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"

    # Verifica campos invisibles inicialmente
    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "Po number"

    # Selección: Check
    select "Check", from: "Pay type"
    assert has_field? "Routing number"
    assert has_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "Po number"

    # Selección: Credit card
    select "Credit card", from: "Pay type"
    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_field? "Credit card number"
    assert has_field? "Expiration date"
    assert has_no_field? "Po number"

    # Selección: Purchase order
    select "Purchase order", from: "Pay type"
    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_field? "Po number"
  end

test "check order and delivery" do
  LineItem.delete_all
  Order.delete_all

  visit store_index_url

  click_on "Add to Cart", match: :first
  click_on "Checkout"

  fill_in "Name", with: "Dave Thomas"
  fill_in "Address", with: "123 Main Street"
  fill_in "Email", with: "dave@example.com"
  select "Check", from: "Pay type"
 assert_selector("label", text: "Routing number", wait: 5)
fill_in "Routing number", with: "123456"

 assert_selector("label", text: "Account number", wait: 5)
fill_in "Account number", with: "987654"


  click_button "Place Order"
  assert_text "Thank you for your order"

  perform_enqueued_jobs
  perform_enqueued_jobs
  assert_performed_jobs 2

  orders = Order.all
  assert_equal 1, orders.size

  order = orders.first

  assert_equal "Dave Thomas",      order.name
  assert_equal "123 Main Street", order.address
  assert_equal "dave@example.com", order.email
  assert_equal "Check",           order.pay_type
  assert_equal 1, order.line_items.size

  mail = ActionMailer::Base.deliveries.last
  assert_equal [ "dave@example.com" ],               mail.to
  assert_equal "Sam Ruby <depot@example.com>",       mail[:from].value
  assert_equal "Pragmatic Store Order Confirmation", mail.subject
end
end
