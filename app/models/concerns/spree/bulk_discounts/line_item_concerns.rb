module Spree
  module BulkDiscounts::LineItemConcerns
    extend ActiveSupport::Concern

    included do
      after_save :update_bulk_discount
      prepend(InstanceMethods)
    end

    module InstanceMethods
      private

      def update_bulk_discount
        Spree::BulkDiscount.adjust(self)
        persist_bulk_discount_total
      end

      def persist_bulk_discount_total
        bulk_discount_total = adjustments.bulk_discount.reload.map do |adjustment|
          adjustment.update!
        end.compact.sum

        update_columns(
            :bulk_discount_total => bulk_discount_total
        ) if changed?
      end
    end
  end
end