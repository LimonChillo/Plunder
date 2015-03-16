require 'test_helper'

class AboutControllerTest < ActionController::TestCase
  test "should get legal" do
    get :legal
    assert_response :success
  end

end
