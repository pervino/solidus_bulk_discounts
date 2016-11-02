require 'spec_helper'

RSpec.describe Spree::BulkDiscount::ItemAdjuster do
  subject(:adjuster) { described_class.new(item) }
  let(:order) { create(:order) }
  let(:variant) { create(:variant) }
  let(:item) { Spree::LineItem.new(order: order, variant: variant) }


  describe 'initialization' do
    it 'sets adjustable' do
      expect(adjuster.item).to eq(item)
    end
  end

  describe '#adjust!' do
    let(:item) { build_stubbed :line_item, order: order }

    context 'when the product has no bulk discount' do
      let(:bulk_discount) { nil }

      before do
        allow(item.product).to receive(:bulk_discount).and_return(nil)
      end

      it 'returns nil early' do
        expect(adjuster.adjust!).to be_nil
      end
    end

    context 'when the product has a bulk discount' do
      before do
        allow(item.product).to receive(:bulk_discount) { build(:bulk_discount) }
        item.price = 10
        item.quantity = 12
      end

      it 'creates an adjustment' do
        expect(adjuster.adjust!).to be_an_instance_of(Spree::Adjustment)
      end
    end
  end
end