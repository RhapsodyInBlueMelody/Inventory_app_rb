class InventoryController < ApplicationController
  before_action :set_inventory_repository

  def index
    @items = @inventory_repository.all
  end

  def show
    @item = @inventory_repository.find(params[:id])
    unless @item
      flash[:alert] = "Item not found."
      redirect_to inventory_index_path
    end
  end

  def new
    # For a new item, you might just have an empty hash or a simple object
    @item = {}
  end

  def create
    item_data = inventory_params.to_h # Convert ActionController::Parameters to a plain Hash
    @created_item = @inventory_repository.create(item_data)
    if @created_item
      flash[:notice] = "Item created successfully!"
      redirect_to inventory_path(@created_item["name"]) # Firebase push uses 'name' for the generated ID
    else
      flash.now[:alert] = "Failed to create item."
      @item = item_data # Retain data for form
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @item = @inventory_repository.find(params[:id])
    unless @item
      flash[:alert] = "Item not found for editing."
      redirect_to inventory_index_path
    end
  end

  def update
    if @inventory_repository.update(params[:id], inventory_params.to_h)
      flash[:notice] = "Item updated successfully!"
      redirect_to inventory_path(params[:id])
    else
      flash.now[:alert] = "Failed to update item."
      @item = @inventory_repository.find(params[:id]) # Re-fetch to populate form
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @inventory_repository.delete(params[:id])
      flash[:notice] = "Item deleted successfully!"
    else
      flash[:alert] = "Failed to delete item."
    end
    redirect_to inventory_index_path
  end

  private

  def set_inventory_repository
    @inventory_repository = InventoryRepository.new
  end

  def inventory_params
    # Define what parameters are permitted for your inventory item
    params.require(:item).permit(:name, :description, :quantity, :price, :category)
  end
end
