class Product < ApplicationRecord
   has_many :line_items
   has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  # Ensure that there are no line items referencing this product
  has_one_attached :image

  after_commit -> { broadcast_refresh_later_to "products" }

  validates :title, :description, :image, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true

  validate :acceptable_image

  def acceptable_image
    return unless image.attached?

    acceptable_types = [ "image/gif", "image/jpeg", "image/png" ]

    unless acceptable_types.include?(image.blob.content_type)
      errors.add(:image, "must be a GIF, JPG or PNG image")
    end
  end
    validates :title, length: { minimum: 10 }

  private
# Ensure that there are no line items referencing this product
def ensure_not_referenced_by_any_line_item
  unless line_items.empty?
    errors.add(:base, "Line Items present")
    raise ActiveRecord::RecordNotDestroyed.new("Cannot delete product with line items", self)
  end
end
end
