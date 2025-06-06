# lib/pago.rb
require "ostruct"

class Pago
  def self.make_payment(order_id:, payment_method:, payment_details:)
    # Implementación simulada (como en el libro)
    sleep 3 unless Rails.env.test?
    OpenStruct.new(succeeded?: true)
  end
end
