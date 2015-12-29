module Spree
  module BulkDiscounts::LineItemConcerns
    extend ActiveSupport::Concern

    included do
      after_save :update_bulk_discount
      # TODO resolve discounted_amount issue or override to include bulk_discount_total
      prepend(InstanceMethods)
    end

    module InstanceMethods
      private

      def update_bulk_discount
        Spree::BulkDiscount.adjust(self)
      end
    end
  end
end