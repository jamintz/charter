require 'test_helper'

class AttributesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get attributes_index_url
    assert_response :success
  end

end
