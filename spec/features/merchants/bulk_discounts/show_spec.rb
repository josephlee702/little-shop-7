require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Show" do
  before :each do
    test_data 
    visit merchant_bulk_discount_path(@merchant1, @discount20)
  end

  describe 'USER STORY 5, MERCHANT BULK DISCOUNT SHOW' do
    it 'has the quantity threshold and percentage discount listed' do
      save_and_open_page
      expect(page).to have_content("Percentage of Discount: 20%")
      expect(page).to have_content("Quantity Threshold: 12")
    end
  end

end