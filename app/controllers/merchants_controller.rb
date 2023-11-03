class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @top = @merchant.top_five_merchant_customers_by_transaction
    #require 'pry'; binding.pry
  end
end