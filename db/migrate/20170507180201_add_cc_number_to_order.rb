class AddCcNumberToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cc_number, :string
  end
end
