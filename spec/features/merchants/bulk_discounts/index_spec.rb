require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Index" do
  before :each do
    test_data 
  end

  describe 'USER STORY 1, MERCHANT BULK DISCOUNTS (BULK DISCOUNTS)' do
    it 'when visiting the merchant dashboard, there is a link to view all discounts' do
      visit merchant_dashboard_index_path(@merchant1)
      click_link "Merchant Discounts"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    end

    it 'bulk discounts index page has all bulk discounts listd including percentage discount and quantity thresholds' do
      visit merchant_bulk_discounts_path(@merchant1)
      discounts = @merchant1.bulk_discounts
      discounts.each do |d|
        expect(page).to have_content("#{d.discount}% off #{d.quantity} items")
      end
    end

    it 'each bulk discount has a link that can be clicked and redirected to the show page' do
      visit merchant_bulk_discounts_path(@merchant1)
      click_link "20% off 12 items"
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount20))
    end
  end


end