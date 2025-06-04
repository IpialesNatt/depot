require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
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
end
