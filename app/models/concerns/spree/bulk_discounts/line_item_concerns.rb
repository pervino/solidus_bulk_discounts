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
      end
    end
  end
end