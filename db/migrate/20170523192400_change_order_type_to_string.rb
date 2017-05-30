class ChangeOrderTypeToString < ActiveRecord::Migration[5.0]
  def up
    change_column :orders, :order_type, :string, null: false
  end

  def down
    change_column :orders, :order_type, :integer, null: false
  end
end
