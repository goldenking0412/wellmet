require 'test_helper'

class HailsControllerTest < ActionController::TestCase
  setup do
    @hail = hails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hail" do
    assert_difference('Hail.count') do
      post :create, hail: { message: @hail.message, to_user_id: @hail.to_user_id, user_id: @hail.user_id }
    end

    assert_redirected_to hail_path(assigns(:hail))
  end

  test "should show hail" do
    get :show, id: @hail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hail
    assert_response :success
  end

  test "should update hail" do
    patch :update, id: @hail, hail: { message: @hail.message, to_user_id: @hail.to_user_id, user_id: @hail.user_id }
    assert_redirected_to hail_path(assigns(:hail))
  end

  test "should destroy hail" do
    assert_difference('Hail.count', -1) do
      delete :destroy, id: @hail
    end

    assert_redirected_to hails_path
  end
end
