module Spree
  module BulkDiscounts::LineItemConcerns
    after_create :update_bulk_discount

    private

    def update_bulk_discount
      Spree::BulkDiscount.adjust(order, [self])
    end
  end
end