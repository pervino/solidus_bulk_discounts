FactoryGirl.define do
  factory :default_bulk_discount_calculator, class: Spree::Calculator::QuantityTieredPercent do
    # % off is 0 - 100. Eg. 50 = 50% 
    preferred_tiers { {12 => 10, 24 => 20} }
  end

  factory :bulk_discount, class: Spree::BulkDiscount do
    name 'Standard'
    association(:calculator, factory: :default_bulk_discount_calculator)
  end
end