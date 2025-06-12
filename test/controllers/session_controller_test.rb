require "test_helper"

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should get firebase_google_auth" do
    get session_firebase_google_auth_url
    assert_response :success
  end
end
