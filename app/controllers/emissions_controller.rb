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
end


 
end
