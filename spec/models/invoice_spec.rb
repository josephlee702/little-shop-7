require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to(:customer) }
  end
  
  describe "validations" do
      it { should validate_presence_of(:customer_id) }
      it { should validate_presence_of(:status) }
  end
  
  describe '#self.incomplete_not_shipped' do
    it 'will return invoices that are incomplete if any invoice items are packaged' do
      test_data
      packaged_invoice = @incomplete
      expect(Invoice.incomplete_not_shipped.include?(packaged_invoice)).to eq(true)
    end
    
    it 'will return invoices that are incomplete if any invoice items are pending' do
      test_data
      packaged_invoice = @incomplete2
      expect(Invoice.incomplete_not_shipped.include?(packaged_invoice)).to eq(true)
    end
  end

  describe "#format_date" do
    it "should return a new format for date created" do 
      test_invoice = create(:invoice, created_at: Time.new(2021, 3, 9))
      expect(test_invoice.format_date).to eq("Tuesday, March  9, 2021")
    end
  end 

  describe "#potential_revenue" do
    it "should return the total potential revenue of that invoice" do 
      test_data
      @test_invoice = @customer1.invoices.first
      @test_invoice.update(status: 0, created_at: Time.new(2021, 12, 30))
      create(:invoice_item, item_id: @item1.id, unit_price: 1500, quantity: 5, invoice_id: @test_invoice.id, status: 2)
      create(:invoice_item, item_id: @item2.id, unit_price: 1850, quantity: 8, invoice_id: @test_invoice.id, status: 2)
      create(:invoice_item, item_id: @item3.id, unit_price: 2500, quantity: 6, invoice_id: @test_invoice.id, status: 1)
      create(:invoice_item, item_id: @item4.id, unit_price: 1200, quantity: 10, invoice_id: @test_invoice.id, status: 2)
      
      expected_total = 0
      @test_invoice.invoice_items.each do |ii|
        expected_total+=(ii.unit_price * ii.quantity)
      end
      expected_total = (0.01 * expected_total).round(2)
      expect(@test_invoice.potential_revenue).to eq(expected_total)
    end
  end 

  describe "#self.sort_alphabetical" do
    it "should sort the invoice data alphabetically" do
      test_data
      alphabetical = Invoice.all.sort
      expect(Invoice.sort_alphabetical).to eq(alphabetical)
    end
  end 

  describe "#self.sort_by_date" do
    it "should sort the invoice data alphabetically" do
      invoice1 = create(:invoice, created_at: Time.new(2022, 3, 9))
      invoice2 = create(:invoice, created_at: Time.new(2021, 3, 9))
      invoice3 = create(:invoice, created_at: Time.new(2020, 3, 9))
      order = [invoice1, invoice2, invoice3]
      expect(Invoice.sort_by_date).to eq(order)
    end
  end 

  describe '#discounted_revenue' do
    it 'calculates the total discounted revenue - Example 3' do
      test_data_E3
      expect(@invoice.discounted_revenue).to eq(174.00)
    end

    it 'calculates the total discounted revenue - Example 5' do
      test_data_E5
      expect(@invoice.discounted_revenue).to eq(280.50)
    end
  end
end