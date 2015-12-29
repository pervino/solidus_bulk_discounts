require 'spec_helper'

describe Spree::BulkDiscount do

  # it "is invalid with 0 quantity" do
  #   FactoryGirl.build(:bulk_discount, :break_points => {"0" => BigDecimal('1')}).should_not be_valid
  # end
  #
  # it "is invalid with a rate over 90%" do
  #   FactoryGirl.build(:bulk_discount, :break_points => {"1" => BigDecimal('0.91')}).should_not be_valid
  # end

  # it "is invalid with no breakpoints" do
  #   FactoryGirl.build(:bulk_discount, :break_points => {}).should_not be_valid
  # end

  it "is invalid with no name" do
    FactoryGirl.build(:bulk_discount, name: nil).should_not be_valid
  end

  context "bulk discount methods" do
    let!(:discount) { create(:bulk_discount) }
    let!(:line_item) { create(:line_item, quantity: 13) }

    before do
      line_item.variant.product.bulk_discount = discount
    end

    it "should fetch the correct rate" do
      expect(discount.getRate(3)).to eq(0)
      expect(discount.getRate(6)).to eq(0.1)
      expect(discount.getRate(15)).to eq(0.15)
      expect(discount.getRate(30)).to eq(0.2)
    end

    it "should compute the correct percentage rate" do
      expect(discount.compute_amount(line_item)).to eq(-19.5)
    end
  end

  describe ".adjust" do
    let(:order) { create(:order) }
    let!(:bulk_discount) { create(:bulk_discount) }

    before do

    end

    context "with line items" do
      let(:product) { create(:product, bulk_discount: bulk_discount, price: 100) }

      let(:line_item) do
        stub_model(Spree::LineItem,
                   :price => 10.0,
                   :quantity => 1,
                   :variant => product.master
        )
      end

      let(:line_items) { [line_item] }

      it "should apply adjustments for the bulk discount to the line_items" do
        expect(bulk_discount).to receive(:adjust)
        Spree::BulkDiscount.adjust(line_items)
      end

      it "should save 10% on 12 items" do
        order.contents.add product.master, 12
        order.update!
        expect(order.bulk_discount_total).to eq(-120)
        expect(order.display_total).to eq(Spree::Money.new(1080))
      end
    end

  end
end