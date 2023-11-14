class AddDiscountedPriceToInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    add_column :invoice_items, :discounted_price, :integer
  end
end
