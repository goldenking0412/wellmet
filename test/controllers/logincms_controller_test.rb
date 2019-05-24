require 'test_helper'

class LogincmsControllerTest < ActionController::TestCase
  setup do
    @logincm = logincms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:logincms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create logincm" do
    assert_difference('Logincm.count') do
      post :create, logincm: { content: @logincm.content }
    end

    assert_redirected_to logincm_path(assigns(:logincm))
  end

  test "should show logincm" do
    get :show, id: @logincm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @logincm
    assert_response :success
  end

  test "should update logincm" do
    patch :update, id: @logincm, logincm: { content: @logincm.content }
    assert_redirected_to logincm_path(assigns(:logincm))
  end

  test "should destroy logincm" do
    assert_difference('Logincm.count', -1) do
      delete :destroy, id: @logincm
    end

    assert_redirected_to logincms_path
  end
end
