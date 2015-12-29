module Spree
  # Manage (recalculate) item (LineItem or Shipment) adjustments
  class ItemAdjustments
    attr_reader :item
    class_attribute :adjustment_hooks

    self.adjustment_hooks = Set.new

    # @param item [Order, LineItem, Shipment] the item whose adjustments should be updated
    def initialize(item)
      @item = item
    end

    # Update the item's adjustments and totals
    #
    # If the item is an {Order}, this will update and select the best
    # promotion adjustment.
    #
    # If it is a {LineItem} or {Shipment}, it will update and select the best
    # promotion adjustment, update tax adjustments, update cancellation
    # adjustments, and then update the total fields (promo_total,
    # included_tax_total, additional_tax_total, and adjustment_total) on the
    # item.
    #
    # This is a noop if the item is not persisted.
    def update
      return @item unless item.persisted?

      # Calculating the totals for the order here would be incorrect. Order's
      # totals are the sum of the adjustments on all child models, as well as
      # its own.
      #
      # We want to select the best promotion for the order, but the remainder
      # of the calculations here are done in the OrderUpdater instead.
      return if Spree::Order === item

      update_promo_totals
      update_tax_totals
      update_adjustment_totals
      persist_totals
      @item
    end

    def self.register_adjustment_hook(method)
      self.adjustment_hooks.add(method)
    end

    def self.unregister_adjustment_hook(method)
      self.adjustment_hooks.delete(method)
    end

    private

    def adjustments
      # This is done intentionally to avoid loading the association. If the
      # association is loaded, the records may become stale due to code
      # elsewhere in spree. When that is remedied, this should be changed to
      # just item.adjustments
      @adjustments ||= item.adjustments.all.to_a
    end

    def update_adjustment_hooks
      total = 0
      self.adjustment_hooks.each do |hook|
        total += self.send(hook) || 0
      end
      total
    end

    def update_promo_totals
      # Promotion adjustments must be applied first, then tax adjustments.
      # This fits the criteria for VAT tax as outlined here:
      # http://www.hmrc.gov.uk/vat/managing/charging/discounts-etc.htm#1
      #
      # It also fits the criteria for sales tax as outlined here:
      # http://www.boe.ca.gov/formspubs/pub113/
      promotion_adjustments = adjustments.select(&:promotion?)
      promotion_adjustments.each(&:update!)
      @item.promo_total = Spree::Config.promotion_chooser_class.new(promotion_adjustments).update
    end

    def update_tax_totals
      # Tax adjustments come in not one but *two* exciting flavours:
      # Included & additional

      # Included tax adjustments are those which are included in the price.
      # These ones should not affect the eventual total price.
      #
      # Additional tax adjustments are the opposite, affecting the final total.
      tax = adjustments.select(&:tax?)

      @item.included_tax_total = tax.select(&:included?).map(&:update!).compact.sum
      @item.additional_tax_total = tax.reject(&:included?).map(&:update!).compact.sum
    end

    def update_adjustment_totals
      item_cancellation_total = adjustments.select(&:cancellation?).map(&:update!).compact.sum
      adjustment_hook_total = update_adjustment_hooks
      @item.adjustment_total = @item.promo_total + @item.additional_tax_total + adjustment_hook_total + item_cancellation_total
    end

    def persist_totals
      @item.update_columns(
          :promo_total => @item.promo_total,
          :included_tax_total => @item.included_tax_total,
          :additional_tax_total => @item.additional_tax_total,
          :adjustment_total => @item.adjustment_total,
          :updated_at => Time.now,
      ) if @item.changed?
    end
  end
end