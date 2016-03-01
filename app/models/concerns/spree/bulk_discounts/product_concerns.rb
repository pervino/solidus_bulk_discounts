module Spree
  module BulkDiscounts::ProductConcerns
    extend ActiveSupport::Concern

    included do
      belongs_to :bulk_discount, class: Spree::BulkDiscount
    end
  end
end
