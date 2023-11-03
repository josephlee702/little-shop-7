class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items

  validates :name, presence: true

  def top_five_merchant_customers_by_transaction(merchant_id)
    Customer
      .joins("JOIN invoices ON customers.id = invoices.customer_id")
      .joins("JOIN transactions ON invoices.id = transactions.invoice_id")
      .joins("JOIN invoice_items ON invoices.id = invoice_items.invoice_id")
      .joins("JOIN items ON invoice_items.item_id = items.id")
      .where("transactions.result = 1 AND items.merchant_id = ?", merchant_id)
      .group("customers.id")
      .select("customers.*, COUNT(transactions.id) AS transaction_count")
      .order("transaction_count DESC")
      .limit(5)
  end
end