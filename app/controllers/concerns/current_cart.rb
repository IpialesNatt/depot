# This module is used to set the current cart for the user.
# It checks if a cart exists in the session, and if not, it creates a new cart.
# The cart is then assigned to an instance variable for use in the controller.

# frozen_string_literal: true

module CurrentCart
  private

  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
