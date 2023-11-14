class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer

  validates :customer_id, presence: true, numericality: true
  validates :status, presence: true

  enum status: {"in progress": 0, "completed": 1, "cancelled": 2}

  def self.incomplete_not_shipped
    Invoice.joins(items: :invoice_items)
           .where(invoice_items: {status: ["pending", "packaged"]})
           .distinct
           .order(created_at: :asc)
  end

  def format_date
    created_at.strftime('%A, %B %e, %Y')
  end

  def potential_revenue
    invoice_items.sum("unit_price * quantity * .01").round(2)
  end

  def self.sort_alphabetical
    Invoice.all.order(id: :asc)
  end

  def self.sort_by_date
    Invoice.all.order(created_at: :desc)
  end

  def discounted_revenue
    total_revenue = 0
    invoice_items.each do |iitem|
      merchant_discounts = iitem.merchant.bulk_discounts
      if merchant_discounts.present?
        applicable_discounts = merchant_discounts.select {|disc| iitem.quantity >= disc.quantity}
        if applicable_discounts.present?
          max_discount = applicable_discounts.max_by{|d| d.discount}
          discounted_price = iitem.unit_price * (1 - max_discount.discount / 100.0)
          iitem.update(unit_price: discounted_price)
        end
      end
      total_revenue += iitem.quantity * iitem.unit_price
    end
    total_revenue/100.00
  end
  
end