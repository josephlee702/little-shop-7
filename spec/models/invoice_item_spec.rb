require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  before :each do
    test_data 
  end

  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_one(:merchant).through(:item) }

  end

  describe "validations" do
    it { should validate_presence_of(:invoice_id) }
    it { should validate_numericality_of(:invoice_id) }
    it { should validate_presence_of(:item_id) }
    it { should validate_numericality_of(:item_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(pending: 0, packaged: 1, shipped: 2) }
  end

  describe '#price' do
    it 'returns the invoice item unit price with a decimal' do
      testing_invoice = create(:invoice_item, unit_price: 2599)
      expect(testing_invoice.price).to eq(25.99)
    end
  end

  describe '#calc_discounted_total' do
    it 'returns the discounted total if there are merchant discounts' do
      test_data_E5
      calculate_percentA = -(@iitemA2.calc_discounted_total / (@iitemA2.quantity * (@iitemA2.unit_price / 100.0)) - 1.0).round(2)
      expect(calculate_percentA).to eq(0.30)
    end
  end

  describe '#bulk_discount_applied?' do
    before :each do
      test_data_E5
    end

    it 'will return true if the bulk discount is applied' do
      expect(@iitemA1.bulk_discount_applied?).to eq(true)
      expect(@iitemA2.bulk_discount_applied?).to eq(true)
    end

    it 'will return false if not' do
      expect(@iitemB.bulk_discount_applied?).to eq(false)
    end
  end

end