class EmissionsController < ApplicationController
  layout 'voter'
 def index
  if params[:query].present?
    q = "%#{params[:query].to_s.strip}%"
    @videos = Video.where(category: "emission")
                   .where("title ILIKE ? OR description ILIKE ?", q, q)
                   .order(created_at: :desc)
  else
    @videos = Video.where(category: "emission").order(created_at: :desc)
  end
 
  # Simple manual pagination (no gem required)
  per_page = (params[:per_page] || 12).to_i
  per_page = 12 if per_page <= 0
  page = params[:page].to_i
  page = 1 if page <= 0

  @total_videos = @videos.count
  @total_pages = (@total_videos / per_page.to_f).ceil
  @page = page
  @per_page = per_page

  @videos = @videos.offset((page - 1) * per_page).limit(per_page)
end


 
end
