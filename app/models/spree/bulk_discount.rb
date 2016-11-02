module Spree
  class BulkDiscount < Spree::Base
    acts_as_paranoid

    # Need to deal with adjustments before calculator is destroyed.
    before_destroy :deals_with_adjustments_for_deleted_source

    include Spree::CalculatedAdjustments
    include Spree::AdjustmentSource

    has_many :products
    has_many :adjustments, as: :source

    after_touch :touch_products

    before_validation :ensure_action_has_calculator
    validates :name, presence: true


    def adjust(item)
      amount = compute_amount(item)
      return if amount == 0

      item.adjustments.create!(
          source: self,
          amount: amount,
          order_id: item.order_id,
          label: create_label(amount)
      )
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

    def touch_products
      products.update_all(updated_at: Time.current)
    end

    def ensure_action_has_calculator
      return if calculator
      self.calculator = Calculator::TieredQuantityPercent.new
    end

    def create_label(amount)
      "Bulk Discount"
    end
  end
end
