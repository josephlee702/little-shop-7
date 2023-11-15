class AddDiscountedTotalToInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    add_column :invoice_items, :discounted_total, :float
  end
end
