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
    if max_discount == "none"
      total = price * quantity.round(2)
      update(discounted_total: total)
      return total
    end

    calc_discounted_total = (price * (1-max_discount.discount/100.0))*quantity.round(2)
    update(discounted_total: calc_discounted_total)
    discounted_total
  end

  def bulk_discount_applied?
    max_discount
    calc_discounted_total != price*quantity.round(2)
  end

  def max_discount
    discounts = merchant.bulk_discounts
    applicable_discounts = discounts.select{|disc| quantity >= disc.quantity}
    return "none" if !applicable_discounts.present? || !discounts.present?
    applicable_discounts.max_by{|d| d.discount}
  end

end