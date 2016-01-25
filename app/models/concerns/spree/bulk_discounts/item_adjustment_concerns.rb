##
# Item Adjustment Concerns
#  - BETA
#
# NOTE: We are going to redo the previous item adjustment integration as we did with spree 2.0
#   This most likely involves the monkey patch we had to make previously however there is an open
#   ticket in solidus to address this problem.
#
#   https://github.com/solidusio/solidus/issues/390
#
# State: not ready
##
module Spree
  module BulkDiscounts::ItemAdjustmentConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def update_bulk_discount_adjustment
        @item.bulk_discount_total = item.adjustments.bulk_discount.reload.map do |adjustment|
          adjustment.update!
        end.compact.sum

        persist_bulk_discount_total
        @item.bulk_discount_total
      end

      def persist_bulk_discount_total
        @item.update_columns(
            :bulk_discount_total => @item.bulk_discount_total
        ) if @item.changed?
      end
    end
  end
end
