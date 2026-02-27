require "test_helper"

class PartenairesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get partenaires_index_url
    assert_response :success
  end
end
