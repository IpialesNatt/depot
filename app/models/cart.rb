class Cart < ApplicationRecord
    # This model represents a shopping cart in the application.
    has_many :line_items, dependent: :destroy
end
