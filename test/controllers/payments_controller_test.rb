require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get webhook" do
    get payments_webhook_url
    assert_response :success
  end
end
