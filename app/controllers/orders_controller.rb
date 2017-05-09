class OrdersController < ApplicationController
  include CurrentCart
  skip_before_action :authorize, only: [:new, :create, :ship]
  before_action :closing, only: :ship
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :set_order, only: [:show, :edit, :update, :destroy, :ship]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @visibility = 'hidden'
  end

  # GET /orders/1/edit
  def edit
    @visibility = @order.pay_type == ('Credit card') ? 'visible' : 'hidden'
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_itmes_from_cart(@cart)
    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderMailer.received(@order).deliver_now #deliver_later
        format.html { redirect_to store_index_url,
          notice: I18n.t('.thanks') }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    check_and_infrom(params[:order])
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order,
          notice: "Order was successfully updated.#{flash[:date_changed]}" }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check_and_infrom(order_data)
    datetime_array = (1..5).map {|x| order_data["ship_date(#{x}i)"].to_i}
    if datetime_array && datetime_array.first(3).all? { |e| e > 0 }
      new_date = DateTime.new(*datetime_array)
      if @order.ship_date == new_date
        flash.now[:date_changed] = ' Shipping date is not changed.'
      end
      unless @order.ship_date
        @order.ship_date = new_date
        OrderMailer.shipped(@order).deliver_now
        flash.now[:date_changed] = ' Order is shipped.'
      end
      unless new_date == @order.ship_date
        @order.ship_date = new_date
        OrderMailer.date_changed(@order).deliver_now
        flash[:date_changed] = ' Shipping date is changed.'
      end
    end
  end

  def ship
    @orders = Order.all
    respond_to do |format|
      if @order.ship_date
        flash.now[:notice] = 'Order is already shipped.'
        format.js
      else
        @order.ship_date = DateTime.now.change({sec: 0})
        if @order.save
          OrderMailer.shipped(@order).deliver_now
          flash.now[:notice] = 'Order is just shipped.'
          format.js
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order)
      .permit(:name, :address, :email, :pay_type, :ship_date, :cc_number)
    end

    def ensure_cart_isnt_empty
      if @cart.line_items.empty?
        redirect_to store_index_url, notice: 'Your cart is empty'
      end
    end

    def closing
      unless Order.find(params[:id]).id
        redirect_to login_url, notice: 'Please log in'
      end
    end
end
