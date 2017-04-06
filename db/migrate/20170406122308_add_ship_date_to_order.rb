class AddShipDateToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :ship_date, :timestamp
  end
end
