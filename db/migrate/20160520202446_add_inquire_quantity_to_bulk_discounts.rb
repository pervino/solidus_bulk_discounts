class AddInquireQuantityToBulkDiscounts < ActiveRecord::Migration
  def change
    add_column :spree_bulk_discounts, :inquire_quantity, :integer
  end
end
