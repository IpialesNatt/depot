# rails80/depot_t/app/models/user.rb
class User < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true

  # Authentication
  has_secure_password

  # Associations
  has_many :sessions, dependent: :destroy

  # Normalization
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Callbacks
  after_destroy :ensure_an_admin_remains

  # Custom error
  class Error < StandardError; end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new("Can't delete last user")
    end
  end
end
