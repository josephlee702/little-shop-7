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

  def calc_discounted_total
    discounts = merchant.bulk_discounts
    return update(discounted_total: unit_price/100.00*quantity) if !discounts.present?

    applicable_discounts = discounts.select{|disc| quantity >= disc.quantity}
    return update(discounted_total: unit_price/100.00*quantity) if !applicable_discounts.present?
    max_discount = applicable_discounts.max_by{|d| d.discount}
    calc_discounted_total = ((unit_price * (1-max_discount.discount/100.0))/100.00)*quantity
    update(discounted_total: calc_discounted_total)
    discounted_total
  end

end