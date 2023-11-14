class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create!(discount: params[:discount], quantity: params[:quantity])
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    if params[:new_disc].present? && params[:new_quantity].present?
      bulk_discount.update!(discount: params[:new_disc])
      bulk_discount.update!(quantity: params[:new_quantity])
      redirect_to merchant_bulk_discount_path(merchant, bulk_discount)
      flash[:alert] = "Update Successful"
    end
  end
end