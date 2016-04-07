module Spree
  module BulkDiscounts::ProductConcerns
    extend ActiveSupport::Concern

    included do
      belongs_to :bulk_discount, class_name: Spree::BulkDiscount
    end
  end
end
