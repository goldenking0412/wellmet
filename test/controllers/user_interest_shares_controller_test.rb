require 'test_helper'

class UserInterestSharesControllerTest < ActionController::TestCase
  setup do
    @current_user = users(:batman)
    sign_in :user, @current_user
  end

  test 'should get index' do
    get :index, format: :json

    assert_response :success
    assert json_response.count > 0
  end

  test 'should create user_interest_share' do
    assert_difference('UserInterestShare.count') do
      post :create,
           user_interest_share: {
             user_id: users(:superman).id,
             user_interest_id: user_interests(:batman_batcopter).id
           },
           format: :json
    end

    user_interest_share = UserInterestShare.last

    assert_equal @current_user.id, user_interests(:batman_batcopter).user_id
    assert_equal user_interests(:batman_batcopter).id,
                 user_interest_share.user_interest_id
  end
end
