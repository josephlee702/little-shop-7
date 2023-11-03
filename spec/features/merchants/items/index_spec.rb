require 'rails_helper'

RSpec.describe 'merchant items index page' do
  before :each do
    @merchant1 = create(:merchant, name: "CamelsRUs")
    @merchant2 = create(:merchant, name: "Pickle Store Depot")

    @item1 = create(:item, merchant_id: @merchant1.id)
    @item2 = create(:item, merchant_id: @merchant1.id)
    @item3 = create(:item, merchant_id: @merchant1.id)
    @item4 = create(:item, merchant_id: @merchant2.id)
  end

  describe 'as a merchant' do
    describe 'when I visit merchant items index page /merchants/:merchant_id/items' do
      it 'shows the list of items name' do
        #US 6
        visit "/merchants/#{@merchant1.id}/items"
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item2.name)
        expect(page).to have_content(@item3.name)
        expect(page).to_not have_content(@item4.name)
        expect(page).to_not have_content(@merchant2.name)
      end

      it 'when I click on an item, it takes to the the show page' do
        #US 7
        visit "/merchants/#{@merchant1.id}/items"

        click_on "#{@item1.name}"

        expect(current_path).to eq("/merchants/#{@merchant1.id}/items/#{@item1.id}")

        expect(page).to have_content("Item Name: #{@item1.name}")
        expect(page).to have_content("Item Description: #{@item1.description}")
        expect(page).to have_content("Item Unit Price: #{@item1.unit_price}")
      end
    end
  end
end