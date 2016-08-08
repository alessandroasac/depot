class AddPaymentTypeToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :payment_type, index: true, foreign_key: true
  end
end
