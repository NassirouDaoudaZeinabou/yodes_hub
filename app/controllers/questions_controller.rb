class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to root_path, notice: "Merci, votre question a été soumise !"
    else
      # remain on home page and show alert
      redirect_to root_path, alert: "Impossible d'envoyer la question."
    end
  end

  private

  def question_params
    params.require(:question).permit(:content)
  end
end
