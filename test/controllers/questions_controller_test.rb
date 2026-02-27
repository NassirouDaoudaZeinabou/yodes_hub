require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should redirect new when not signed in" do
    get new_question_url
    assert_redirected_to new_user_session_path
  end

  test "signed in user can access new" do
    user = users(:one)
    sign_in user
    get new_question_url
    assert_response :success
  end

  test "create saves question" do
    user = users(:one)
    sign_in user
    assert_difference("Question.count", 1) do
      post questions_url, params: { question: { content: "Quel est votre parcours ?" } }
    end
    assert_redirected_to root_path
  end

  test "invalid submission redirects with alert" do
    user = users(:one)
    sign_in user
    assert_no_difference("Question.count") do
      post questions_url, params: { question: { content: "" } }
    end
    assert_redirected_to root_path
    assert_equal "Impossible d'envoyer la question.", flash[:alert]
  end
end
