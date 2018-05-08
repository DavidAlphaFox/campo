class Topic < ApplicationRecord
  has_many :comments, counter_cache: true
  belongs_to :forum
  belongs_to :user

  validates :title, :content, presence: true

  before_create :set_activated_at

  scope :page, -> (page) { offset(page.to_i * 25).limit(25) }

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end
end
