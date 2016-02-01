class ConvertSpreeBdToSolidus < ActiveRecord::Migration
  def up
    Spree::BulkDiscount.all.each do |bulk_discount|
      unless bulk_discount.calculator.present?
        legacy_tiers = YAML.load(bulk_discount.break_points)
        legacy_tiers.each do |quantity, percent|
          legacy_tiers[quantity] = (percent * 100).to_i
        end

        # Create calculator
        calculator = Spree::Calculator::QuantityTieredPercent.new(preferred_tiers: legacy_tiers)
        calculator.save!

        # Set it
        bulk_discount.calculator = calculator
        bulk_discount.save!
      end
    end

    if column_exists? :spree_bulk_discounts, :break_points
      remove_column :spree_bulk_discounts, :break_points
    end
  end

  def down
    unless column_exists? :spree_bulk_discounts, :break_points
      add_column :spree_bulk_discounts, :break_points, :text
    end

    Spree::BulkDiscount.all.each do |bulk_discount|
      if bulk_discount.calculator.present?
        tiers = bulk_discount.calculator.preferred_tiers
        tiers.each do |quantity, percent|
          tiers[quantity] = BigDecimal.new(percent / 100)
        end

        bulk_discount.break_points = tiers
        bulk_discount.save!
      end
    end
  end
end
