module Spree
  module BulkDiscounts::AdjustmentConcerns
    scope :bulk_discount, -> { where(source_type: 'Spree::BulkDiscount') }

    # @return [Boolean] true when this is a bulk discount adjustment (Bulk Discount adjustments have a {BulkDiscount} source)
    def bulk_discount?
      source_type == 'Spree::BulkDiscount'
    end
  end
end
