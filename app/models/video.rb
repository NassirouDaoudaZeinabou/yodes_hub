class Video < ApplicationRecord
  belongs_to :candidate
     include PgSearch::Model 


  pg_search_scope :search_by_keywords,
    against: [:title],  
    using: {
      tsearch: { prefix: true, any_word: true },
      trigram: {}
    }
  
  # Optional uploaded thumbnail for better previews (admins can upload)
  has_one_attached :thumbnail
end
