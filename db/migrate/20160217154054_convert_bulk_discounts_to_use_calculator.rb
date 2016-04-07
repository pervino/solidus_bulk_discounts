class ConvertBulkDiscountsToUseCalculator < ActiveRecord::Migration
  def change
    Spree::BulkDiscount.find_each do |bulk_discount|
      break_points = YAML::load(bulk_discount.break_points)
      tiers = break_points.update(break_points) { |key, value| value * 100 }
      calculator = Spree::Calculator::TieredQuantityPercent.new(preferred_tiers: tiers)
      calculator.save

      bulk_discount.calculator = calculator
      bulk_discount.save
    end

    add_index :spree_products, :bulk_discount_id
    remove_column :spree_bulk_discounts, :break_points
  end
end
