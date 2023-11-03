class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.update(name: params[:new_name])
    redirect_to "/admin/merchants/#{@merchant.id}"

    if @merchant.update(name: params[:new_name])
      flash[:alert] = "Update Successful"
    end
  end
end
