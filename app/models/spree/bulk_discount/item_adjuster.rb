module Spree
  # Adjust a single customizable item (line item or shipment)
  class BulkDiscount::ItemAdjuster
    attr_reader :item

    # @param [Spree::LineItem,Spree::Shipment] item to adjust
    def initialize(item)
      @item = item
    end

    # Deletes all existing customization adjustments and creates new adjustments
    # for all applicable customization fees.
    #
    # Creating the adjustments will also run the ItemAdjustments class and
    # persist all totals on the item.
    #
    # @return [Array<Spree::Adjustment>] newly created adjustments
    def adjust!
      return unless item.instance_of?(Spree::LineItem)

      item.adjustments.bulk_discount.destroy_all

      item.product.bulk_discount.adjust(item) if item.product.bulk_discount.present?
    end
  end
end