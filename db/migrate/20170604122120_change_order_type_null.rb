class ChangeOrderTypeNull < ActiveRecord::Migration[5.0]
  def up
    change_column :orders, :order_type, :string
  end

  def down
    change_column :orders, :order_type, :string, null: false
  end
end
