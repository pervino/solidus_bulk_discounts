module Spree
  module Admin
    class BulkDiscountsController < ResourceController
      before_action :load_calculators

      private

      def load_calculators
        @calculators = BulkDiscount.calculators.sort_by(&:name)
      end
    end
  end
end
