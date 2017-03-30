class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart

  @@count = 0
  @@old_total_price = LineItem.all.to_a.sum {|item| item.total_price}

  def index
    @products = Product.order(:title)

    @@count += 1 if session[:counter].nil?
    new_total_price = LineItem.all.to_a.sum {|item| item.total_price}
    unless @@old_total_price == new_total_price
      @@count = 0
      @@old_total_price = new_total_price
    end
    @count = @@count
  end


end
