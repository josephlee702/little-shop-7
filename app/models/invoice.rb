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
    invoice_items.each do |iitem|
      iitem.calc_discounted_total
    end
    invoice_items.sum(:discounted_total).round(2)
  end
  
end