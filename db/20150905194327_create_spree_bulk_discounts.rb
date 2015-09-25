class CreateSpreeBulkDiscounts < ActiveRecord::Migration
  def change
    create_table :spree_bulk_discounts do |t|
      t.string :name
      t.reference :calculator

      t.datetime :deleted_at
      t.timestamps
    end

    add_column :spree_products, :bulk_discount_id, :integer
    add_column :spree_line_items, :bulk_discount_total, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :spree_shipments, :bulk_discount_total, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
