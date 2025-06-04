class RemovePayTypeFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :pay_type, :integer
  end
end
