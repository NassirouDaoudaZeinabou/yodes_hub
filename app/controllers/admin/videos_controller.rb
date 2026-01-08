class Admin::VideosController < ApplicationController
  before_action :authenticate_user!
   before_action :authorize_admin
  before_action :set_video, only: %i[show edit update destroy]
   layout 'admin'
  def index
    @videos = Video.includes(:candidate).order(created_at: :desc)
    @candidate_videos=Video.where(category: "candidate")
    @emission_videos=Video.where(category: "emission")
  end

  def show
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to admin_video_path(@video), notice: 'Vidéo créée avec succès.'
    else
      flash.now[:alert] = 'Impossible de créer la vidéo.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @video.update(video_params)
      redirect_to admin_video_path(@video), notice: 'Vidéo mise à jour.'
    else
      flash.now[:alert] = 'Impossible de mettre à jour la vidéo.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video.destroy
    redirect_to admin_videos_path, notice: 'Vidéo supprimée.'
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :url, :description, :candidate_id,:thumbnail)
  end

  # Basic admin gate used across admin controllers
  def authorize_admin
    return unless current_user

    if current_user.respond_to?(:admin?)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.admin?
    elsif current_user.respond_to?(:role)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.role == 'admin'
    end
  end
end

