class AddTitleIndexToProducts < ActiveRecord::Migration[5.0]
  def change
    add_index :products, :title
  end
end
