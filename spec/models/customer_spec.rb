require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe "#name" do
    it "will return the first and last name of the customer as one" do
      customer = create(:customer)
      full_name = customer.first_name + " " + customer.last_name
      expect(customer.name).to eq(full_name)
    end
  end
end