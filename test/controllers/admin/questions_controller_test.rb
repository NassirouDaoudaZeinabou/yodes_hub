require "test_helper"

class Admin::QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @question = questions(:one)
    @admin_user = users(:one)
    @admin_user.update(role: 'admin')
  end

  test "index redirects if not authenticated" do
    get admin_questions_url
    assert_redirected_to new_user_session_path
  end

  test "index shows all questions for admin" do
    sign_in @admin_user
    get admin_questions_url
    assert_response :success
    assert_select "h1", "Gestion des Questions"
  end

  test "show displays question details" do
    sign_in @admin_user
    get admin_question_url(@question)
    assert_response :success
    assert_select "h1", /Question ##{@question.id}/
  end

  test "new displays form for creating question" do
    sign_in @admin_user
    get new_admin_question_url
    assert_response :success
    assert_select "h2", "Nouvelle Question"
  end

  test "create saves new question" do
    sign_in @admin_user
    assert_difference("Question.count") do
      post admin_questions_url, params: {
        question: {
          content: "Nouvelle question de test",
          user_id: @user.id
        }
      }
    end
    assert_redirected_to admin_question_path(Question.last)
  end

  test "edit displays form for editing question" do
    sign_in @admin_user
    get edit_admin_question_url(@question)
    assert_response :success
    assert_select "h2", "Modifier la Question"
  end

  test "update modifies existing question" do
    sign_in @admin_user
    new_content = "Contenu modifié"
    patch admin_question_url(@question), params: {
      question: {
        content: new_content,
        user_id: @user.id
      }
    }
    assert_redirected_to admin_question_path(@question)
    @question.reload
    assert_equal new_content, @question.content
  end

  test "destroy removes question" do
    sign_in @admin_user
    assert_difference("Question.count", -1) do
      delete admin_question_url(@question)
    end
    assert_redirected_to admin_questions_path
  end
end

