require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  test 'should get index' do
    sign_in :user, users(:batman)
    get :index, format: :json
    assert_response :success
    assert json_response.count > 0
  end

  test 'should create answer' do
    user = users(:hulk)
    question = questions(:who_am_i)

    sign_in :user, user
    assert_difference('Answer.count') do
      post :create,
           format: :json,
           answer: {
             question_id: question.id,
             text: 'Thor'
           }
    end

    assert_response :created

    answer = Answer.last

    assert_equal user.id, answer.user_id
    assert_equal question.id, answer.question_id
    assert_equal 'Thor', answer.text
  end

  test 'should update answer' do
    question = Question.create(user: users(:batman), text: 'Who is my butler?')
    answer = users(:superman).answers.create(text: 'Alfred', question: question)

    sign_in :user, users(:batman)
    patch :update, id: answer.id, answer: { appreciated: true }, format: :json

    answer.reload
    assert answer.id
  end
end
