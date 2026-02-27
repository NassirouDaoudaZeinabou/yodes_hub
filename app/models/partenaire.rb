class Partenaire < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

  scope :ordered, -> { order(name: :asc) }

 
end
