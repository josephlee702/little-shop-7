class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items

  validates :name, presence: true

  def top_five_merchant_customers_by_transaction
    Customer
    .joins("JOIN invoices ON invoices.customer_id = customers.id")
    .joins("JOIN transactions ON transactions.invoice_id = invoices.id")
    .joins("JOIN invoice_items ON invoice_items.items_id = items.id")
    .joins("JOIN invoice_items ON invoice_items.invoice_id = invoice.id")
    .where("transactions.result = 1 AND invoices.id IN (SELECT invoice_id FROM items WHERE items.merchant_id = ?)", 9)
    .group("customers.id")
    .select("customers.*, COUNT(transactions.id) AS transaction_count")
    .order("transaction_count DESC")
    .limit(5)
  end
end