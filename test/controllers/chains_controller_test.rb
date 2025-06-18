require "test_helper"

class ChainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chains_index_url
    assert_response :success
  end

  test "should get show" do
    get chains_show_url
    assert_response :success
  end
end
