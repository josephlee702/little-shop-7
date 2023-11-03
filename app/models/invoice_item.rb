class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  enum status: {"pending": 0, "packaged": 1, "shipped": 2}
 
  validates :invoice_id, presence: true, numericality: true
  validates :item_id, presence: true, numericality: true
  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true
  
end