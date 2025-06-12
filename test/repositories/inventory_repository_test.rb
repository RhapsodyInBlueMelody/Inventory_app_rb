require "test_helper"
require "mocha/minitest" # You'll need this gem for mocking/stubbing

class InventoryRepositoryTest < ActiveSupport::TestCase
  # This setup runs before each test
  setup do
    # Mock the Firebase client for testing
    @mock_firebase_client = mock("Firebase::Client")
    @repository = InventoryRepository.new(@mock_firebase_client)
  end

  test "should return all items from firebase" do
    # Define what the mock client's 'get' method should return
    firebase_response_body = {
      "id1" => { "name" => "Laptop", "quantity" => 5 },
      "id2" => { "name" => "Mouse", "quantity" => 20 }
    }
    # This stubs the 'get' method for the specific path and returns a success response
    @mock_firebase_client.expects(:get).with("inventory").returns(
      stub(success?: true, body: firebase_response_body)
    )

    items = @repository.all
    assert_equal 2, items.count
    assert_equal "Laptop", items.first["name"]
    assert_equal "id1", items.first["id"] # Check that 'id' is merged
  end

  test "should return empty array if firebase get fails" do
    @mock_firebase_client.expects(:get).with("inventory").returns(
      stub(success?: false, body: nil) # Simulate a failed response
    )

    items = @repository.all
    assert_empty items
  end

  # Add more tests for create, find, update, delete
  # ... (similar mocking for push, update, delete methods)
end
