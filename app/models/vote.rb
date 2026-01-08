class Vote < ApplicationRecord
  # belongs_to :candidate
 
belongs_to :candidate

  STATUSES = %w[pending paid failed]

  validates :phone_number, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }

  before_validation :set_default_status, on: :create

  scope :paid, -> { where(status: "paid") }

  private

  def set_default_status
    self.status ||= "pending"
  end
end

