class Candidate < ApplicationRecord
has_many :videos, dependent: :destroy
has_many :votes


    has_one_attached :image

    include PgSearch::Model 


  pg_search_scope :search_by_keywords,
    against: [:name],  
    using: {
      tsearch: { prefix: true, any_word: true },
      trigram: {}
    }
    has_many :votes, dependent: :destroy

  def total_votes
    votes.paid.count
  end
    has_many :votes

  def valid_votes_count
    votes.valid.count
  end
end
