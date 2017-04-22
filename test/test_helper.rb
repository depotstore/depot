ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

end

class ActionDispatch::IntegrationTest

  def login_as(user)
    post login_url, params: { name: user.name, password: 'secret' }
  end

  def logout
    delete logout_url
  end

  def setup
    login_as User.first
  end

  def setup_urls
    @urls = [products_url, line_items_url, carts_url, orders_url, users_url]

    @urls_id =
      ["/products/#{Product.first.id}", "/products/#{Product.last.id}",
        "/line_items/#{LineItem.first.id}","/line_items/#{LineItem.last.id}",
        "/carts/#{Cart.first.id}", "/carts/#{Cart.last.id}",
        "/orders/#{Order.first.id}", "/orders/#{Order.last.id}"]
  end

  def setup_extras
    @update = {
                title: 'Lorem Ipsum',
                description: 'Wibbles are fun!',
                image_url: 'lorem.jpg',
                price: 19.95
              }

    @order = orders(:one)

    @tested_order = {
                address: @order.address,
                email: @order.email,
                name: @order.name,
                pay_type: @order.pay_type
              }

    @user = {
              name: 'sam',
              password: 'secret',
              password_confirmation: 'secret'
            }
  end


end
