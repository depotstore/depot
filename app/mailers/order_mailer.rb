class OrderMailer < ApplicationMailer
  default from: 'Depot Store <depotstoreinfo@gmail.com>'

  def received(order)
    @order = order
    # attachments['7apps.jpg'] = File.read('app/assets/images/7apps.jpg')
    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end

  def shipped(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end

  def date_changed(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Order Shipping date was changed'
  end

end
