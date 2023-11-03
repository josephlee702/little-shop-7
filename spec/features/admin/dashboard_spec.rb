require "rails_helper"

RSpec.describe "Admin Dashboard" do
  before :each do
    @customer1 = create(:customer)
    @customer2 = create(:customer)
    @customer3 = create(:customer)
    @customer4 = create(:customer)
    @customer5 = create(:customer)

    @test_customers = [@customer1, @customer2, @customer3, @customer4, @customer5]

    count = 25
    @test_customers.each do |customer|
      invoices = []
      count.times do
        invoices << create(:invoice, customer_id: customer.id)
      end
      invoices = invoices.map{|i| i.id}
      invoices.each{|id| create(:transaction, result: 1, invoice_id: id)}
      count-=1
    end
    
  end

  ## USER STORY 19
  it "displays a header indicating that I am on the admin dashboard" do
    visit "/admin"
    expect(page).to have_content("Admin Dashboard")
  end

  ## USER STORY 20
  it "when visiting the admin dashboard, it has a link for the admin merchants index" do
    visit "/admin"
    click_link("Admin Merchants Index")
    expect(current_path).to eq("/admin/merchants")
  end

  it "has a link for the admin invoices index" do
    visit "/admin"
    click_link("Admin Invoices Index")
    expect(current_path).to eq("/admin/invoices")
  end

  ## USER STORY 21
  it "when visiting the dashboard, the names of the top 5 customers with the largest number of successful transactions appears" do
    visit "/admin"
    expect(page).to have_content("Top 5 Customers with the Most Successful Transactions")
    expect(@customer1.name).to appear_before(@customer2.name)
    expect(@customer2.name).to appear_before(@customer3.name)
    expect(@customer3.name).to appear_before(@customer4.name)
    expect(@customer4.name).to appear_before(@customer5.name)
  end

end
