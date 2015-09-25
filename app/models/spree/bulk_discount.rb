module Spree
  class BulkDiscount < Spree::Base
    acts_as_paranoid

    # Need to deal with adjustments before calculator is destroyed.
    before_destroy :deals_with_adjustments_for_deleted_source

    include Spree::CalculatedAdjustments
    include Spree::AdjustmentSource

    validates :amount, presence: true, numericality: true

    # Deletes all bulk discount adjustments, then applies all applicable
    # discounts to relevant items
    def self.adjust(order)
      items = order.line_items
      relevant_items = items.select { |item| item.product.bulk_discount.present? }
      unless relevant_items.empty?
        Spree::Adjustment.where(adjustable: relevant_items).bulk_discount.destroy_all # using destroy_all to ensure adjustment destroy callback fires.
      end
      relevant_items.each do |item|
        item.variant.product.bulk_discount.adjust(order, item)
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
          label: create_label
      )
      true
    end

    # Ensure a negative amount which does not exceed the sum of the order's
    # item_total and ship_total
    def compute_amount(calculable)
      calculator.compute(item) * -1
    end

    private

    def create_label
      label = ""
      label << "Bulk Discount"
      label << " - #{amount * 100}%"
      label
    end
  end
end
