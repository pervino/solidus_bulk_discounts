module Spree
  module Admin
    class BulkDiscountsController < ResourceController
      before_action :load_calculators

      private

      def load_calculators
        @calculators = Rails.application.config.spree.calculators.bulk_discounts.sort_by(&:name)
      end
    end
  end
end
