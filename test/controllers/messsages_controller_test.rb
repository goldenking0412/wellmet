require 'test_helper'

class MesssagesControllerTest < ActionController::TestCase
  setup do
    @messsage = messsages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messsages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create messsage" do
    assert_difference('Messsage.count') do
      post :create, messsage: { from_user_id: @messsage.from_user_id, text: @messsage.text, to_user_id: @messsage.to_user_id }
    end

    assert_redirected_to messsage_path(assigns(:messsage))
  end

  test "should show messsage" do
    get :show, id: @messsage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @messsage
    assert_response :success
  end

  test "should update messsage" do
    patch :update, id: @messsage, messsage: { from_user_id: @messsage.from_user_id, text: @messsage.text, to_user_id: @messsage.to_user_id }
    assert_redirected_to messsage_path(assigns(:messsage))
  end

  test "should destroy messsage" do
    assert_difference('Messsage.count', -1) do
      delete :destroy, id: @messsage
    end

    assert_redirected_to messsages_path
  end
end
