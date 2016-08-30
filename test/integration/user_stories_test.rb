require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products, :payment_types, :orders

  # A user goes to the index page. They select a product, adding it to their​
  # cart, and check out, filling in their details on the checkout form. When​
  # they submit, an order is created containing their information, along with a​
  # single line item corresponding to the product they added to their cart.​

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
    check = payment_types(:check)

    get '/'
    assert_response :success
    assert_template 'index'

    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get '/orders/new'
    assert_response :success
    assert_template 'new'

    post_via_redirect '/orders', order: { name: 'Dave Thomas',
      address: '123 The Street', email: 'dave@example.com', payment_type_id: check.id }
    assert_response :success
    assert_template 'index'
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal 'Dave Thomas', order.name
    assert_equal '123 The Street', order.address
    assert_equal 'dave@example.com', order.email
    assert_equal check, order.payment_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['dave@example.com'], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject
  end

  test "sending mail on error" do
    begin
      get '/carts/aaa'
    rescue
    end
    assert_response :redirect

    mail = ActionMailer::Base.deliveries.last
    assert_equal "Application Error Notification", mail.subject
    assert_equal ["alessandro.asac@gmail.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "Couldn't find Cart with 'id'=aaa", mail.body.encoded
  end

  test "sending mail on ship date update" do
    login_as(:one)
    order = orders(:one)
    patch order_path(order, order: { name: order.name,
                                     address: order.address,
                                     email: order.email,
                                     payment_type_id: order.payment_type.id,
                                     ship_date: Date.current })

    mail = ActionMailer::Base.deliveries.last
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal [order.email], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "Pragmatic Order Shipped", mail.body.encoded
    assert_template '_line_item'
    assert_match order.line_items.first.product.title, mail.body.encoded
  end

end
