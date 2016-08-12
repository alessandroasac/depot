class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :payment_type, required: true
  validates :name, :address, :email, presence: true
  after_update :send_ship_email, if: :ship_date_changed?

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price
    line_items.map(&:total_price).sum
  end

  private

    def send_ship_email
      OrderNotifier.shipped(self).deliver_now
    end
end
