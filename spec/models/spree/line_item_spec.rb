require 'spec_helper'

describe Spree::LineItem do
  let(:discount) { create(:bulk_discount) }
  let(:product) { create(:product, bulk_discount: discount) }
  let(:subject) { create(:line_item, quantity: 1, price: 10, product: product) }

  it "should not have adjustments for invalid quantity" do
    expect(subject.adjustments.count).to eql 0
    expect(subject.bulk_discount_total).to eql 0
  end

  describe "creates the adjustments" do
    let(:subject) { create(:line_item, quantity: 110, price: 10, product: product) }

    it "on initial create" do
      expect(subject.adjustments.count).to eql 1
      expect(subject.bulk_discount_total).to eql -220
    end

    it "when updating the quantity" do
      subject.quantity = 13
      subject.save!
      expect(subject.adjustments.count).to eql 1
      expect(subject.discounted_amount).to eql 110.5
      expect(subject.bulk_discount_total).to eql -13
    end
  end
end