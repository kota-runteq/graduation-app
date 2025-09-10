require "test_helper"

class ChainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chains_url
    assert_response :success
  end

  test "should get show" do
    get chain_url(chains(:mcd))
    assert_response :success
  end
end
