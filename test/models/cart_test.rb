require 'test_helper'

class CartTest < ActiveSupport::TestCase

  def setup
    @cart = Cart.create!
    @rails_test = products(:rails_test)
    @ruby = products(:ruby)
  end

  test "should add unique products" do
    @cart.add_product(@rails_test.id, @rails_test.price)
    assert_equal 1, @cart.line_items.size
    assert_equal @rails_test.price, @cart.total_price
    assert_equal 1, @cart.line_items.to_a.sum{ |item| item.quantity }

    @cart.add_product(@ruby.id, @ruby.price)
    assert_equal 2, @cart.line_items.size
    assert_equal @ruby.price + @rails_test.price, @cart.total_price
    assert_equal 2, @cart.line_items.to_a.sum{ |item| item.quantity }
  end

  test "should add duplicated product" do
    @cart.add_product(@ruby.id, @ruby.price)
    @cart.save!

    assert_equal 1, @cart.line_items.size
    assert_equal @ruby, @cart.line_items.first.product
    assert_equal @ruby.price, @cart.total_price
    assert_equal 1, @cart.line_items.to_a.sum{ |item| item.quantity }


    item = @cart.add_product(@ruby.id, @ruby.price)
    item.save!
    @cart.reload

    assert_equal 1, @cart.line_items.size
    assert_equal 2, @cart.line_items.first.quantity
    assert_equal (@ruby.price * 2), @cart.total_price
    assert_equal 2, @cart.line_items.to_a.sum{ |item| item.quantity }
  end
end
