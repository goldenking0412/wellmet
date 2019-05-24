require 'test_helper'

class UserBlocksControllerTest < ActionController::TestCase
  setup do
    @user_block = user_blocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_blocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_block" do
    assert_difference('UserBlock.count') do
      post :create, user_block: { blocked_user_id: @user_block.blocked_user_id, user_id: @user_block.user_id }
    end

    assert_redirected_to user_block_path(assigns(:user_block))
  end

  test "should show user_block" do
    get :show, id: @user_block
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_block
    assert_response :success
  end

  test "should update user_block" do
    patch :update, id: @user_block, user_block: { blocked_user_id: @user_block.blocked_user_id, user_id: @user_block.user_id }
    assert_redirected_to user_block_path(assigns(:user_block))
  end

  test "should destroy user_block" do
    assert_difference('UserBlock.count', -1) do
      delete :destroy, id: @user_block
    end

    assert_redirected_to user_blocks_path
  end
end
