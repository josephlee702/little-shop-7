require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should have_many(:transactions) }
    # it { should belong_to(:customer) }
    # it { should have_many(:items).through(:)}

  end

  describe "validations" do
    it { should validate_presence_of(:customer_id) }
    it { should validate_presence_of(:status) }
  end

end