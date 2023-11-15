require "rails_helper"

RSpec.describe "Admin Invoices Show" do
  before(:each) do
    test_data
    @test_invoice = @customer1.invoices.first
    @test_invoice.update(status: 0, created_at: Time.new(2021, 12, 30))
    create(:invoice_item, item_id: @item1.id, unit_price: 500, quantity: 5, invoice_id: @test_invoice.id, status: 2)
    create(:invoice_item, item_id: @item2.id, unit_price: 1850, quantity: 8, invoice_id: @test_invoice.id, status: 2)
    create(:invoice_item, item_id: @item3.id, unit_price: 1000, quantity: 6, invoice_id: @test_invoice.id, status: 1)
    create(:invoice_item, item_id: @item4.id, unit_price: 1200, quantity: 10, invoice_id: @test_invoice.id, status: 2)
  end

  ## USER STORY 33
  describe 'Admin Invoices Show Page' do
    before :each do
      @test_invoice = @customer1.invoices.first
      @test_invoice.update(created_at: Time.new(2021, 12, 30))
    end
    it "when visiting show page, returns ID, status, creation date, and full name of customer on invoice" do
      visit "/admin/invoices/#{@test_invoice.id}"

      expect(page).to have_content(@test_invoice.id)
      expect(page).to have_content(@test_invoice.status.titleize)
      expect(page).to have_content("Thursday, December 30, 2021")
      expect(page).to have_content(@test_invoice.customer.name)
    end

  end

  ## USER STORY 34
  it "has all of the items on the invoice including its name, quantity, price sold, and status" do
    visit "/admin/invoices/#{@test_invoice.id}"
    @test_invoice.invoice_items.each do |ii|
      expect(page).to have_content(ii.item.name)
      expect(page).to have_content(ii.quantity)
      expect(page).to have_content(ii.price)
      expect(page).to have_content(ii.status.capitalize)
    end
  end

  ## USER STORY 35
  it "displays the total potential revenue of the invoice" do
    visit "/admin/invoices/#{@test_invoice.id}"
    expected_total = 0
    @test_invoice.invoice_items.each do |ii|
      expected_total+=(ii.unit_price * ii.quantity)
    end
    expected_total = (0.01 * expected_total)
    expect(page).to have_content("Total Potential Revenue: $#{expected_total.round(2)}")
  end

  ## USER STORY 36
  it "when visiting the show page, an invoice status can be updated with a select field option, already defaulted as the current status" do
    visit "/admin/invoices/#{@test_invoice.id}"
    expect(page).to have_content("In Progress")
    expect(page).to have_select("status_update", :with_options => ["In Progress", "Completed", "Cancelled"])
  end

  it "can select a new status and update the invoice - Completed" do
    visit "/admin/invoices/#{@test_invoice.id}"
    select "Completed", :from => "status_update"
    click_button "Update Invoice Status"
    expect(current_path).to eq("/admin/invoices/#{@test_invoice.id}")
    expect(page).to have_content("Completed")
  end

  it "can select a new status and update the invoice - In Progress" do
    visit "/admin/invoices/#{@test_invoice.id}"
    select "In Progress", :from => "status_update"
    click_button "Update Invoice Status"
    expect(current_path).to eq("/admin/invoices/#{@test_invoice.id}")
    expect(page).to have_content("In Progress")
  end

  it "can select a new status and update the invoice - Cancelled" do
    visit "/admin/invoices/#{@test_invoice.id}"
    select "Cancelled", :from => "status_update"
    click_button "Update Invoice Status"
    expect(current_path).to eq("/admin/invoices/#{@test_invoice.id}")
    expect(page).to have_content("Cancelled")
  end

  describe 'USER STORY 8, ADMIN INVOICE SHOW PAGE: TOTAL REVENUE AND DISCOUNTED REVENUE' do
    before :each do
      test_data
      test_revenue
      visit admin_invoice_path(@test_invoice)
    end

    it 'when visiting the show page, the total revenue from this invoice is displayed' do
      expect(page).to have_content("Total Potential Revenue: $#{@expected_revenue}")
    end

    it 'also includes the total discounted revenue' do
      expect(page).to have_content("Total Discounted Revenue: $384.20")
    end
  end

end