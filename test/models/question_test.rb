require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "requires content" do
    q = Question.new(user: users(:one))
    assert_not q.valid?
    assert_includes q.errors[:content], "can't be blank"

    q.content = "Bonjour, quelle est votre stratégie ?"
    assert q.valid?
  end
end
