require "test_helper"
require "mocha/minitest"

class InventoryControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Mock the repository itself or the Firebase client within the repository
    @mock_inventory_repository = mock("InventoryRepository")
    # This stubs the `new` method of InventoryRepository to return our mock instance
    InventoryRepository.stubs(:new).returns(@mock_inventory_repository)
  end

  test "should get index and display items" do
    # Define what the mock repository's 'all' method should return
    mock_items = [
      { "id" => "id1", "name" => "Mock Item 1", "quantity" => 10 },
      { "id" => "id2", "name" => "Mock Item 2", "quantity" => 20 }
    ]
    @mock_inventory_repository.expects(:all).returns(mock_items)

    get inventory_index_url # Use the helper for your index path

    assert_response :success
    assert_select "h1", "Inventory Items" # Check for a heading you expect in your view
    assert_select "li", text: "Mock Item 1" # Check for content from your mock data
    assert_select "li", text: "Mock Item 2"
  end

  test "should show item" do
    mock_item = { "id" => "id1", "name" => "Single Mock Item", "quantity" => 5 }
    @mock_inventory_repository.expects(:find).with("id1").returns(mock_item)

    get inventory_url("id1") # Use the helper for your show path with an ID

    assert_response :success
    assert_select "h1", text: "Single Mock Item" # Check for content
  end

  def index
    @items = @inventory_repository.all
    respond_to do |format|
      format.html # This explicitly says "respond with HTML for HTML requests"
      # If you later add PDF:
      # format.pdf do
      #   render pdf: "inventory_report", template: "inventory/index", layout: "pdf"
      # end
    end
  end

  def show
    @item = @inventory_repository.find(params[:id])
    unless @item
      flash[:alert] = "Item not found."
      redirect_to inventory_index_path and return # Add 'and return' to prevent double render
    end
    respond_to do |format|
      format.html
    end
  end
end
