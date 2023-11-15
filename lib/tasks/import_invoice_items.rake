namespace :csv_load do
  desc "TODO"
  task invoice_items: :environment do
    require "csv"

    csv_text = File.read(Rails.root.join("db", "data", "invoice_items.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      t = InvoiceItem.new
      t.item_id = row["item_id"]
      t.invoice_id = row["invoice_id"]
      t.quantity = row["quantity"]
      t.unit_price = row["unit_price"]
      t.status = row["status"].to_i
      t.discounted_total = 0.00
      t.save
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end  
  puts "Seeded bro bro"
end
