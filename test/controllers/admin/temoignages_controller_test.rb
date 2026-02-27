require "test_helper"

class Admin::TemoignagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_temoignages_index_url
    assert_response :success
  end
end
