class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    require 'pry'; binding.pry
    #@top = @merchant.top_five_merchant_customers_by_transaction(@merchant.id)
  end
end