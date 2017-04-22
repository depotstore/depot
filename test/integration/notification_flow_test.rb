require 'test_helper'

class NotificationFlowTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  setup do
    order = orders(:one)
  end

  test "shipping an order" do
    #testing ship method. Date is correct.
    order = Order.last
    assert_nil order.ship_date
    post "/orders/#{order.id}/ship", xhr: true
    order = Order.last
    assert_equal DateTime.now.utc.change({sec: 0}).to_s, order.ship_date.to_s
    #Notification is sent.
    mail = ActionMailer::Base.deliveries.last
    assert_equal ['foravitosells@gmail.com'], mail.to
    assert_equal 'Depot Store <depotstoreinfo@gmail.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Shipped', mail.subject

    #testing update method. Ship date was changed.
    put "/orders/#{order.id}", params: {
      order: {
        'ship_date(1i)' => '2017', 'ship_date(2i)' => '11',
        'ship_date(3i)' => '10', 'ship_date(4i)' => '10',
        'ship_date(5i)' => '10',
      }
    }
    order = Order.last
    assert_equal '2017-11-10 10:10:00 UTC', order.ship_date.to_s

    #Notification is sent.
    mail = ActionMailer::Base.deliveries.last
    assert_equal ['foravitosells@gmail.com'], mail.to
    assert_equal 'Depot Store <depotstoreinfo@gmail.com>', mail[:from].value
    assert_equal 'Pragmatic Order Shipping date was changed', mail.subject

  end

  test 'notification is sent' do
    get '/carts/w'
    mail = ActionMailer::Base.deliveries.last
    assert_equal ['foravitosells@gmail.com'], mail.to
    assert_equal 'Depot Store <depotstoreinfo@gmail.com>', mail[:from].value
    assert_equal 'Notification about errors.', mail.subject

  end
end
