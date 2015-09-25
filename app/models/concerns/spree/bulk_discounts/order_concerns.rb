module Spree
  module BulkDiscounts::OrderConcerns
    extend ActiveSupport::Concern

    included do
      money_methods :bulk_discount_total
    end
  end
end
