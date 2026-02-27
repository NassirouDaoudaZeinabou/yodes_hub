require "test_helper"

class TemoignagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get temoignages_index_url
    assert_response :success
  end
end
