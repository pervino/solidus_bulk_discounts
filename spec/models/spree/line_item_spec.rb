require 'spec_helper'

describe Spree::LineItem do
  let!(:discount) { create(:bulk_discount) }
  let(:subject) { create(:line_item, quantity: 1, price: 10, product: create(:product, bulk_discount: discount)) }

  it "should not have adjustments for invalid quantity" do
    expect(subject.adjustments.count).to eql 0
    expect(subject.bulk_discount_total).to eql 0
  end

  describe "creates the adjustments" do
    it "on initial create" do
      new_line_item = create(:line_item, quantity: 10, price: 10, product: line_item.product)
      expect(new_line_item.adjustments.count).to eql 1
      expect(new_line_item.bulk_discount_total).to eql -10
    end

    it "when updating the quantity" do
      line_item.quantity = 13
      line_item.save!
      expect(line_item.adjustments.count).to eql 1
      expect(line_item.discounted_amount).to eql 110.5
      expect(line_item.bulk_discount_total).to eql -19.5
    end
  end
end