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
end