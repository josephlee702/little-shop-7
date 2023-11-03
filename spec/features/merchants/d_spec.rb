require "rails_helper"

RSpec.describe "Dashboard" do
  it "US3: has names of the top 5 customers with the count of their successful transactions" do
    # 3. Merchant Dashboard Statistics - Favorite Customers
    # As a merchant,
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    # Then I see the names of the top 5 customers
    # who have conducted the largest number of successful transactions with my merchant
    # And next to each customer name I see the number of successful transactions they have
    # conducted with my merchant
    @customer1 = Customer.create(first_name: "Angus", last_name: "Turing")
    @customer2 = Customer.create(first_name: "Boyardee", last_name: "Turing")
    @customer3 = Customer.create(first_name: "Camoflauge", last_name: "Turing")
    @customer4 = Customer.create(first_name: "Derelict", last_name: "Turing")
    @customer5 = Customer.create(first_name: "Nathan", last_name: "Turing")
    @customer6 = Customer.create(first_name: "Enmity", last_name: "Turing")

    @merchant1 = Merchant.create!(name: "Billy")

    @invoice1 = @customer1.invoices.create(status: 1)
    @invoice6 = @customer1.invoices.create(status: 1)
    @invoice2 = @customer2.invoices.create(status: 1)
    @invoice3 = @customer3.invoices.create(status: 1)
    @invoice4 = @customer4.invoices.create(status: 1)
    @invoice5 = @customer5.invoices.create(status: 1)

    @item1 = @merchant1.items.create(name: "Hat", description: "Hat", unit_price: 100)
    @item2 = @merchant1.items.create(name: "Bat", description: "Bat", unit_price: 100)

    @transaction1 = @invoice1.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)
    @transaction2 = @invoice2.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)
    @transaction3 = @invoice3.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)
    @transaction4 = @invoice4.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)
    @transaction5 = @invoice5.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)
    @transaction6 = @invoice6.transactions.create(credit_card_number: 1234, credit_card_expiration_date: 01/11, result: 1)

    InvoiceItem.create(item_id: @item1.id, invoice_id: @invoice1.id)
    InvoiceItem.create(item_id: @item2.id, invoice_id: @invoice6.id)
    InvoiceItem.create(item_id: @item1.id, invoice_id: @invoice2.id)
    InvoiceItem.create(item_id: @item1.id, invoice_id: @invoice3.id)
    InvoiceItem.create(item_id: @item1.id, invoice_id: @invoice4.id)
    InvoiceItem.create(item_id: @item1.id, invoice_id: @invoice5.id)

    visit "/merchants/#{@merchant1.id}/dashboard"
    expect(page).to have_content("Angus")
    expect(page).to have_content("Boyardee")
    expect(page).to have_content("Camoflauge")
    expect(page).to have_content("Derelict")
    expect(page).to have_content("Nathan")
    expect(page).to have_content(2)
    expect(page).to have_content(1)
    expect(page).to_not have_content("Enmity")
    expect(page).to_not have_content(0)
  end
end