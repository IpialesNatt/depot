class AddPaymentTypeToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :payment_type, null: true, foreign_key: true
  end
end
