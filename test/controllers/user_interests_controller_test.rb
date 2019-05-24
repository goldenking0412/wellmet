require 'test_helper'

class UserInterestsControllerTest < ActionController::TestCase
  setup do
    @current_user = users(:batman)
    sign_in :user, @current_user
  end

  test 'should create user_interests' do
    get :index, format: :json

    assert_difference('UserInterest.count') do
      post :create,
           user_interest: {
             interest_id: interests(:batsling).id,
             comment: 'Let me swing on buildings'
           },
           format: :json
    end

    user_interest = UserInterest.last
    assert_equal interests(:batsling).id, user_interest.interest_id
    assert_equal 'Let me swing on buildings', user_interest.comment
    assert_equal @current_user.id, user_interest.user_id
  end

  test 'should destroy interests_user' do
    assert_difference('UserInterest.count', -1) do
      delete :destroy, id: user_interests(:batman_batcopter), format: :json
    end
  end
end
