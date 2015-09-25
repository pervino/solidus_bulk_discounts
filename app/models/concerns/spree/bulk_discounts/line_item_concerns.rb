module Spree
  module BulkDiscounts::LineItemConcerns
    extend ActiveSupport::Concern

    included do
      after_create :update_bulk_discount
    end

    module InstanceMethods
      private

      def update_bulk_discount
        Spree::BulkDiscount.adjust(self)
      end
    end
  end
end