FactoryGirl.define do
  factory :default_bulk_discount_calculator, class: Spree::Calculator::TieredPercent do
    preferred_tiers { {12 => 0.1, 24 => 0.2} }
  end

  factory :bulk_discount, class: Spree::BulkDiscount do
    name 'Standard'
    association(:calculator, factory: default_bulk_discount_calculator)
  end
end