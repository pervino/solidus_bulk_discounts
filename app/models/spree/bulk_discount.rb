module Spree
  class BulkDiscount < Spree::Base
    acts_as_paranoid

    has_many :products

    before_validation :ensure_action_has_calculator
    before_destroy :deals_with_adjustments_for_deleted_source
    after_touch :touch_all_products

    include Spree::CalculatedAdjustments
    include Spree::AdjustmentSource

    validates :name, presence: true

    # Deletes all bulk discount adjustments, then applies all applicable
    # discounts to relevant items
    def self.adjust(adjustable)
      return unless adjustable.instance_of?(Spree::LineItem)

      if adjustable.product.bulk_discount.present?
        Spree::Adjustment.where(adjustable: adjustable).bulk_discount.destroy_all # using destroy_all to ensure adjustment destroy callback fires.
        adjustable.variant.product.bulk_discount.adjust(adjustable)
      end
    end

    def adjust(item)
      amount = compute_amount(item)
      return if amount == 0

      Spree::Adjustment.create!(
          amount: amount,
          order_id: item.order_id,
          adjustable: item,
          source: self,
          label: create_label(amount)
      )
      true
    end

    # Ensure a negative amount which does not exceed the sum of the order's
    # item_total and ship_total
    def compute_amount(calculable)
      calculator.compute(calculable) * -1
    end

    def tiers
      calculator.preferred_tiers
    end

    private

    def touch_all_products
      products.update_all(updated_at: Time.current)
    end

    def ensure_action_has_calculator
      return if calculator
      self.calculator = Calculator::TieredQuantityPercent.new
    end

    def create_label(amount)
      label = ""
      label << "Bulk Discount"
      label
    end
  end
end
