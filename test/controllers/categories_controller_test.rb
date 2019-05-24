require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, format: :json
    assert_response :success
    assert json_response.count > 0
  end
end
