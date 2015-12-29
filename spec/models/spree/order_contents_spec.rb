require 'spec_helper'

describe Spree::OrderContents, :type => :model do
  let(:order) { create(:order) }
  let(:variant) { create(:variant) }

  subject { described_class.new(order) }

  before do
    variant.product.bulk_discount = create(:bulk_discount)
  end

  context "#add" do

    it 'should trigger the first bulk discount pricing' do
      line_item = subject.add(variant, 10)
      expect(line_item.total.round(2)).to eq(179.91)
    end

    it 'should trigger the second bulk discount pricing' do
      line_item = subject.add(variant, 13)
      expect(line_item.total.round(2)).to eq(220.89)
    end

    it 'should trigger the third bulk discount pricing' do
      line_item = subject.add(variant, 20)
      expect(line_item.total.round(2)).to eq(319.84)
    end

  end

  context "#remove" do

    it 'should reduce line_item quantity if quantity is less the line_item quantity' do
      line_item = subject.add(variant, 7)
      subject.remove(variant, 2)

      expect(line_item.reload.total.to_f).to eq(99.95)
    end

  end
end