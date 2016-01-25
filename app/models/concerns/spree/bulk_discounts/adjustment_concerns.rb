module Spree
  module BulkDiscounts::AdjustmentConcerns
    extend ActiveSupport::Concern

    included do
      class_attribute :competing_promos
      self.competing_promos = Set.new ['Spree::PromotionAction', 'Spree::BulkDiscount']

      scope :bulk_discount, -> { where(source_type: 'Spree::BulkDiscount') }
      scope :promotions, -> { where(source_type: self.competing_promos) }

      prepend(InstanceMethods)
    end

    module InstanceMethods
      # @return [Boolean] true when this is a bulk discount adjustment (Bulk Discount adjustments have a {BulkDiscount} source)
      def bulk_discount?
        source_type == 'Spree::BulkDiscount'
      end

      def competing_promos?
        self.competing_promos.include? source_type
      end
    end
  end
end
