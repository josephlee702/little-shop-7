require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Edit" do
  before :each do
    test_data 
  end
  
  describe 'USER STORY 5, MERCHANT BULK DISCOUNT EDIT' do
    it 'when visiting the discount show page, there is a link to edit the discount' do
      visit merchant_bulk_discount_path(@merchant1, @discount20)
      expect(page).to have_link("Edit Discount")
      click_link "Edit Discount"
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount20))
    end

    it 'has a form to edit the discount with current attributes pre-populated in the form' do
      visit edit_merchant_bulk_discount_path(@merchant1, @discount20)
      expect(page).to have_field(:new_disc, with: "#{@discount20.discount}")
      expect(page).to have_field(:new_quantity, with: "#{@discount20.quantity}")
      fill_in :new_quantity, with: "5"
      click_on("Submit")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount20))
      expect(page).to have_content("Quantity Threshold: 5")
    end
  end

end