class ScrapingTask < ApplicationRecord
  belongs_to :user

  validates :url, presence: true
  validates :user, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending in_progress completed failed] }

  enum status: { pending: 0, in_progress: 1, completed: 2, failed: 3 }
end
