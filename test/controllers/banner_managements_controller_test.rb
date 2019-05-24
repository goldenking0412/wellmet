require 'test_helper'

class BannerManagementsControllerTest < ActionController::TestCase
  setup do
    @banner_management = banner_managements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:banner_managements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create banner_management" do
    assert_difference('BannerManagement.count') do
      post :create, banner_management: { heading: @banner_management.heading, name: @banner_management.name, position: @banner_management.position, subtitle1: @banner_management.subtitle1, subtitle2: @banner_management.subtitle2, title: @banner_management.title }
    end

    assert_redirected_to banner_management_path(assigns(:banner_management))
  end

  test "should show banner_management" do
    get :show, id: @banner_management
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @banner_management
    assert_response :success
  end

  test "should update banner_management" do
    patch :update, id: @banner_management, banner_management: { heading: @banner_management.heading, name: @banner_management.name, position: @banner_management.position, subtitle1: @banner_management.subtitle1, subtitle2: @banner_management.subtitle2, title: @banner_management.title }
    assert_redirected_to banner_management_path(assigns(:banner_management))
  end

  test "should destroy banner_management" do
    assert_difference('BannerManagement.count', -1) do
      delete :destroy, id: @banner_management
    end

    assert_redirected_to banner_managements_path
  end
end
