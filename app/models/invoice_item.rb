class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  enum status: {"pending": 0, "packaged": 1, "shipped": 2}
 
  validates :invoice_id, presence: true, numericality: true
  validates :item_id, presence: true, numericality: true
  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true
  
  def price
    (unit_price * 0.01).round(2)
  end

  def discounted_price
    discounts = merchant.bulk_discounts
    applicable_discounts = discounts.select{|disc| quantity >= disc.quantity}
    return unit_price unless applicable_discounts.present?
    max_discount = applicable_discounts.max_by{|d| d.discount}
    discounted_price = unit_price * (1-max_discount.discount/100.0)

    update(discounted_price: discounted_price)
    discounted_price
  end

end