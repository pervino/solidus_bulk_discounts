require 'spec_helper'

describe Spree::Order, :type => :model do

  let(:user) { stub_model(Spree::User, :email => "spree@example.com", :password => "password123") }
  let(:order) { stub_model(Spree::Order, :user => user) }

  context "#display_bulk_discount_total" do
    it "returns the value as a spree money" do
      allow(order).to receive(:bulk_discount_total) { 10.55 }
      expect(order.display_bulk_discount_total).to eq(Spree::Money.new(10.55, :currency=>"USD"))
    end
  end

end
