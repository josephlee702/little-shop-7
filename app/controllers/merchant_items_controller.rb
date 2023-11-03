class MerchantItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @item = Item.find(params[:item_id])
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  def update
    @item = Item.find(params[:item_id])
    @item.update(item_params)
    redirect_to "/merchants/#{@item.merchant.id}/items/#{@item.id}"
    if @item.update(item_params)
      flash[:alert] = "Update successful"
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end