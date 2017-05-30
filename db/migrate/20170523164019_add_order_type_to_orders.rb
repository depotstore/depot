class AddOrderTypeToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :order_type, :integer
  end
end
