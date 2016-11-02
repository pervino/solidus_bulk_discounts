FactoryGirl.define do
  factory :default_bulk_discount_calculator, class: Spree::Calculator::TieredQuantityPercent do
    preferred_tiers { {12 => 10, 24 => 20} }
  end

  factory :bulk_discount, class: Spree::BulkDiscount do
    name 'Standard'
    association(:calculator, factory: :default_bulk_discount_calculator)
  end
end