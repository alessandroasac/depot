class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :payment_type, required: true
  validates :name, :address, :email, presence: true

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price
    line_items.map(&:total_price).sum
  end
end
