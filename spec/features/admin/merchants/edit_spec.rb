require "rails_helper"

RSpec.describe "the merchants update page" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Sooyung LLC")
    @merchant2 = Merchant.create!(name: "Joseph LLC")
    @merchant3 = Merchant.create!(name: "Anthea LLC")
    @merchant4 = Merchant.create!(name: "Nathan LLC")
  end

  it "shows me a link to update the merchant" do
    visit "/admin/merchants/#{@merchant1.id}"
    expect(page).to have_content(@merchant1.name)
    expect(page).to have_link("Update Merchant")
  end

  it "shows me a form filled in with the company name and updates the information when i submit a different merchant name in the text box" do
    visit "/admin/merchants/#{@merchant1.id}"
    click_on("Update Merchant")
    expect(page).to have_current_path("/admin/merchants/#{@merchant1.id}/edit")
    expect(page).to have_field(:new_name, with: "#{@merchant1.name}")
    fill_in :new_name, with: "Company Test Name"
    click_on("Submit")
    expect(page).to have_current_path("/admin/merchants/#{@merchant1.id}")
    expect(page).to have_content("Company Test Name")
    expect(page).to have_content("Update Successful")
  end
end
