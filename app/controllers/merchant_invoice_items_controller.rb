class MerchantInvoiceItemsController < ApplicationController

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @invoice_item = InvoiceItem.find(params[:invoice_item_id])
    if params[:status_update] == "pending"
      @invoice_item.update(status: "pending")
    elsif params[:status_update] == "packaged"
      @invoice_item.update(status: "packaged")
    else params[:status_update] == "shipped"
      @invoice_item.update(status: "shipped")
    end
    redirect_to "/merchants/#{params[:merchant_id]}/invoices/#{params[:invoice_id]}"
  end
end