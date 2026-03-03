class Admin::QuestionsController < ApplicationController
  # authentication / admin guard
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_question, only: %i[show edit update destroy]

  layout 'admin'

  def index
    @questions = Question.order(created_at: :desc)
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to admin_question_path(@question), notice: "Question créée avec succès."
    else
      flash.now[:alert] = "Impossible de créer la question."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to admin_question_path(@question), notice: "Question mise à jour."
    else
      flash.now[:alert] = "Impossible de mettre à jour la question."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_questions_path, notice: "Question supprimée."
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content, :user_id)
  end

  def authorize_admin
    return unless current_user

    if current_user.respond_to?(:admin?)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.admin?
    elsif current_user.respond_to?(:role)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.role == 'admin'
    end
  end
end
