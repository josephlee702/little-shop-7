class MerchantItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if params[:item_update] == "Update_item"
      update_item(@item)
    else params[:commit].present?
      update_enable(@item)
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new(item_params)
    if @item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      redirect_to "/merchants/#{@merchant.id}/items/new"
      flash[:alert] = "Error: Please fill in all the criteria"
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end

  def update_enable(item)
    if params[:commit] == "Enable"
      item.update(enable: true)     
    elsif params[:commit] == "Disable"
      item.update(enable: false)
    end
    redirect_to "/merchants/#{item.merchant.id}/items"
  end

  def update_item(item)
    item.update(item_params)
    flash[:alert] = "Update successful"
    redirect_to "/merchants/#{item.merchant.id}/items/#{item.id}"
  end
end