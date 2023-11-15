require 'rails_helper'

RSpec.describe 'merchant items index page' do
  before :each do
    @merchant11 = create(:merchant, name: "CamelsRUs")
    @merchant22 = create(:merchant, name: "Pickle Store Depot")

    @item21 = create(:item, merchant_id: @merchant11.id)
    @item22 = create(:item, name: "Pickles", merchant_id: @merchant11.id)
    @item23 = create(:item, merchant_id: @merchant11.id, enable: false)
    @item24 = create(:item, merchant_id: @merchant22.id)
    @item25 = create(:item)
    test_data_2
  end

  describe 'as a merchant' do
    describe 'when I visit merchant items index page /merchants/:merchant_id/items' do
      it 'shows the list of items name' do
        #US 6
        visit "/merchants/#{@merchant11.id}/items"
        expect(page).to have_content(@item21.name)
        expect(page).to have_content(@item22.name)
        expect(page).to have_content(@item23.name)
        expect(page).to_not have_content(@item24.name)
        expect(page).to_not have_content(@merchant22.name)
      end

      it 'when I click on an item, it takes to the the show page' do
        #US 7
        visit "/merchants/#{@merchant11.id}/items"

        click_on "#{@item21.name}"

        expect(current_path).to eq("/merchants/#{@merchant11.id}/items/#{@item21.id}")

        expect(page).to have_content("Item Name: #{@item21.name}")
        expect(page).to have_content("Item Description: #{@item21.description}")
        expect(page).to have_content("Item Unit Price: #{@item21.unit_price}")
      end

      it 'has a button to enable item' do
        merchant11 = create(:merchant, name: "CamelsRUs")
        item21 = create(:item, merchant_id: merchant11.id)
        item22 = create(:item, merchant_id: merchant11.id)
        item23 = create(:item, merchant_id: merchant11.id, enable: false)

        #US 9
        visit "/merchants/#{merchant11.id}/items"

        within("#enabled_item-#{item21.id}") do
          expect(page).to have_button("Disable")
          click_button "Disable"
          expect(page).to_not have_button('Disable')
        end
        
        within("#enabled_item-#{item22.id}") do
          expect(page).to have_button("Disable")
        end

        within("#disabled_item-#{item23.id}") do
          expect(page).to have_button("Enable")
          click_button "Enable"
          expect(page).to_not have_content(item23.name)
        end
        
        expect(current_path).to eq("/merchants/#{merchant11.id}/items")
      end

      it 'shows two sections, enabled items and disabled items and items listed appropriately' do
        #US 10
        visit "/merchants/#{@merchant11.id}/items"

        expect(page).to have_content("Enabled Items")
        expect(page).to have_content("Disabled Items")
        expect(@item21.name).to appear_before("Disabled Items")
        expect(@item22.name).to appear_before("Disabled Items")
        expect("Disabled Items").to appear_before(@item23.name)
      end

      it 'has a link to create a new item and add to index' do
        #US 11
        visit "/merchants/#{@merchant11.id}/items"

        expect(page).to have_link("Create a new item")

        click_link("Create a new item")

        expect(current_path).to eq("/merchants/#{@merchant11.id}/items/new")

        expect(page).to have_field("Item Name")
        expect(page).to have_field("Item Description")
        expect(page).to have_field("Item Unit Price")

        fill_in("Item Name", with: "Jerky")
        fill_in("Item Description", with: "Jerky for energy")
        fill_in("Item Unit Price", with: 10)

        click_button("Submit")

        expect(current_path).to eq("/merchants/#{@merchant11.id}/items")
        expect(page).to have_content("Jerky")
      end

      it 'gives an error if you do not fill in everything when creating a new item' do
        #US 11
        visit "/merchants/#{@merchant11.id}/items/new"

        fill_in("Item Name", with: "Jerky")
        fill_in("Item Description", with: "")
        fill_in("Item Unit Price", with: 10)

        click_button("Submit")
        expect(page).to have_content("Error: Please fill in all the criteria")
      end


      it 'shows top 5 popular items ranked by total revenue' do
        #US 12
        visit "/merchants/#{@merchant1.id}/items"
        expect(page).to have_content("Top 5 Popular Items and Revenue")

        within("#popular_items-#{@merchant1.id}") do
          expect(@item4.name).to appear_before(@item3.name)
          expect(@item3.name).to appear_before(@item2.name)
          expect(@item2.name).to appear_before(@item1.name)
          expect(@item1.name).to appear_before(@item7.name)
          expect(page).to have_content("300.00")
          expect(page).to have_content("242.00")
          expect(page).to have_content("40.40")
          expect(page).to have_content("50.00")
          expect(page).to have_content("22.25")
        end
      end

      it 'shows date of most sales for top 5 popular items' do
        #US 13
        
        visit "/merchants/#{@merchant1.id}/items"
        
        expect(page).to have_content("Top day for #{@item3.name}: Sunday, January 1, 2023")
        expect(page).to have_content("Top day for #{@item4.name}: Sunday, January 1, 2023")
        expect(page).to have_content("Top day for #{@item2.name}: Tuesday, February 1, 2022")
        expect(page).to have_content("Top day for #{@item1.name}: Monday, March 1, 2021")
        expect(page).to have_content("Top day for #{@item7.name}: Monday, March 1, 2021")
      end
    end
  end
end