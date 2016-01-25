module SolidusBulkDiscounts
  class Engine < Rails::Engine
    require "solidus_core"

    isolate_namespace Spree
    engine_name "solidus_bulk_discounts"

    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      if Rails.env.test?
        # Maybe move into solidus_item_designs
        Dir.glob(File.join(File.dirname(__FILE__), '../solidus/**/*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      Spree::Order.register_update_hook(:persist_bulk_discount_totals)
    end

    initializer 'spree.promo.register.promotion.calculators' do |app|
      app.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::QuantityTieredPercent
    end

    config.to_prepare &method(:activate).to_proc
  end
end