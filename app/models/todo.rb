class Todo < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :completed, inclusion: { in: [ true, false ] }

  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }
end
