require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  test 'should get index' do
    sign_in :user, users(:batman)
    get :index, format: :json
    assert_response :success
    assert json_response.count > 0
  end

  test 'should create question' do
    sign_in :user, users(:batman)

    assert_difference('Question.count') do
      post :create,
           question: { text: 'What is wrong with this world?' }, format: :json
    end

    question = Question.last

    assert_equal users(:batman).id, question.user_id
    assert_equal 'What is wrong with this world?', question.text
  end
end
