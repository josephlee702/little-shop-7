require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Index" do
  before :each do
    test_data 
    visit merchant_bulk_discounts_path(@merchant1)
  end

  describe 'USER STORY 1, MERCHANT BULK DISCOUNTS (BULK DISCOUNTS)' do
    it 'when visiting the merchant dashboard, there is a link to view all discounts' do
      visit merchant_dashboard_index_path(@merchant1)
      click_link "Merchant Discounts"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    end

    it 'bulk discounts index page has all bulk discounts listd including percentage discount and quantity thresholds' do
      discounts = @merchant1.bulk_discounts
      discounts.each do |d|
        expect(page).to have_content("#{d.discount}% off #{d.quantity} items")
      end
    end

    it 'each bulk discount has a link that can be clicked and redirected to the show page' do
      click_link "20% off 12 items"
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount20))
    end
  end

  describe 'USER STORY 2, MERCHANT BULK DISCOUNT CREATAE' do
    it 'has a link to create a new discount that will redirect user to form' do
      expect(page).to have_link("Create New Discount")
      click_link "Create New Discount"
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    end

    it "can fill in the new discount information and create a new discount" do
      visit new_merchant_bulk_discount_path(@merchant1)
      fill_in "Percentage of Discount", with: 50
      fill_in "Quantity", with: 40
      click_button "Submit"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).to have_content("50% off 40 items")
    end
  end

  describe 'USER STORY 3, MERCHANT BULK DISCOUNT DELETE' do
    it 'next to each bulk discount there is a button to delete' do
      button_count = @merchant1.bulk_discounts.count
      expect(page).to have_selector('button', text: 'Delete', count: button_count)
    end

    it "when user clicks a delete button, it removes the discount and redirects to index page" do
      within("#bulkdiscount-#{@discount15.id}") do
        click_button "Delete"
      end
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).to_not have_content("15% off 10 items")
    end
  end
end