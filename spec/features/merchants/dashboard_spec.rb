require "rails_helper"

RSpec.describe "Dashboard" do
  before :each do
    test_data 
  end

  it "US1: shows the name of the merchant" do
    # 1. Merchant Dashboard
    # As a merchant,
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    # Then I see the name of my merchant
    visit "/merchants/#{@merchant1.id}/dashboard"
    # visit merchant_dashboard_index_path

    expect(page).to have_content(@merchant1.name)
    expect(page).to_not have_content(@merchant2.name)
  end

  it "US2: has a link to merchant items and invoices indexes" do
    # 2. Merchant Dashboard Links
    # As a merchant,
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    # Then I see link to my merchant items index (/merchants/:merchant_id/items)
    # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
    visit "/merchants/#{@merchant1.id}/dashboard"
    expect(page).to have_link("Merchant Items")
    expect(page).to have_link("Merchant Invoices")
    click_link("Merchant Items")
    expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
    click_link("#{@item1.name}")
    expect(current_path).to eq("/merchants/#{@merchant1.id}/items/#{@item1.id}")
    expect(page).to have_content(@item1.name)
    visit "/merchants/#{@merchant1.id}/dashboard"
    click_link("Merchant Invoices")
    expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices")
    expected_invoices = [@incomplete, @incomplete2]
    expect(page).to have_content(@incomplete.id)
    expect(page).to have_content(@incomplete2.id)
    click_link("#{@incomplete.id}")
    expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@incomplete.id}")
    expect(page).to have_content(@incomplete.status)
  end
  
  ## USER STORY 3
  it "has names of the top 5 customers with the count of their successful transactions" do
    visit "/merchants/#{@merchant1.id}/dashboard"
    expected_order = [@customer1, @customer2, @customer3, @customer4, @customer5]
    expect(@customer1.name).to appear_before(@customer2.name)
    expect(@customer2.name).to appear_before(@customer3.name)
    expect(@customer3.name).to appear_before(@customer4.name)
    expect(@customer4.name).to appear_before(@customer5.name)
  end

  it 'includes number of successful transactions beside each customer name' do
    visit "/merchants/#{@merchant1.id}/dashboard"
    expected_order = [@customer1, @customer2, @customer3, @customer4, @customer5]
    expected_order.each do |c|
      expect(page).to have_content("#{c.transactions.count} purchases")
    end
  end

  ## USER STORY 4
  it "US4: has section for 'items ready to ship'" do
    # 4. Merchant Dashboard Items Ready to Ship
    # As a merchant
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    # Then I see a section for "Items Ready to Ship"
    # In that section I see a list of the names of all of my items that
    # have been ordered and have not yet been shipped,
    # And next to each Item I see the id of the invoice that ordered my item
    # And each invoice id is a link to my merchant's invoice show page
    @customer0 = Customer.create(first_name: "Angus", last_name: "Turing")
    @invoice0 = @customer0.invoices.create(status: 1)

    @item2 = @merchant1.items.create(name: "Bat", description: "Bat", unit_price: 200)
    @item3 = @merchant1.items.create(name: "Cat", description: "Cat", unit_price: 300)
    @item4 = @merchant1.items.create(name: "Rat", description: "Rat", unit_price: 400)

    @transaction0 = @invoice0.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)

    @ii1 = create(:invoice_item, item: @item2, invoice: @invoice0, status: 0)
    @ii2 = create(:invoice_item, item: @item3, invoice: @invoice0, status: 1)
    @ii3 = create(:invoice_item, item: @item4, invoice: @invoice0, status: 2)


    visit "/merchants/#{@merchant1.id}/dashboard"
    expect(page).to have_content("Items Ready to Ship")
    within("#Items-Ready-to-Ship") do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@item3.name)
      expect(page).to_not have_content(@item4.name)
    end
    within("#Items-Ready-to-Ship") do
      expect(page).to have_content(@invoice0.id)
    end
    click_link("#{@invoice0.id}", match: :first)
    expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice0.id}")
  end
  it "US5: in the section for 'items ready to ship' I see date invoice was created formatted like 'Monday, July 18, 2019' and ordered oldest to newest" do
    # 5. Merchant Dashboard Invoices sorted by least recent
    # As a merchant
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    # In the section for "Items Ready to Ship",
    # Next to each Item name I see the date that the invoice was created
    # And I see the date formatted like "Monday, July 18, 2019"
    # And I see that the list is ordered from oldest to newest
    @customer0 = Customer.create(first_name: "Angus", last_name: "Turing")
    @invoice0 = @customer0.invoices.create(status: 1)
    @invoice7 = @customer0.invoices.create(status: 1)

    @item2 = @merchant1.items.create(name: "Bat", description: "Bat", unit_price: 200)
    @item3 = @merchant1.items.create(name: "Cat", description: "Cat", unit_price: 300)
    @item4 = @merchant1.items.create(name: "Rat", description: "Rat", unit_price: 400)

    @transaction0 = @invoice0.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)
    @transaction7 = @invoice0.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)

    @ii1 = create(:invoice_item, item: @item2, invoice: @invoice0, status: 0)
    @ii2 = create(:invoice_item, item: @item3, invoice: @invoice0, status: 1)
    @ii3 = create(:invoice_item, item: @item4, invoice: @invoice0, status: 2)
    @ii7 = create(:invoice_item, item: @item3, invoice: @invoice0, status: 2)

    @invoice0.update(created_at: '1999-01-01 00:00:00')
    date = Date.today.strftime('%A, %B %e, %Y')

    visit "/merchants/#{@merchant1.id}/dashboard"
    expect(page).to have_content("Items Ready to Ship")
    expect(page).to have_content("Friday, January 1, 1999")
    expect(@invoice0.created_at.strftime('%A, %B %e, %Y')).to appear_before(@invoice7.created_at.strftime('%A, %B %e, %Y'))
  end

end