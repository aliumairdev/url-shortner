# frozen_string_literal: true

class Url < ApplicationRecord
  SHORT_URL_REGEX = /\A[A-Z]{5}\z/

  # validations
  validates :short_url, presence: true
  validates :short_url, uniqueness: true
  validates :short_url, format: SHORT_URL_REGEX
  validates :original_url, format: URI::regexp

  # callbacks
  before_create :set_default_click_count
  # scopes
  scope :latest, -> { order("created_at DESC").limit(10)}

  # associations
  has_many :clicks

  # methods
  def set_default_click_count
    clicks_count = 0
  end

  def generate_short_url
    loop do
      short_url = SecureRandom.send(:choose, [*'A'..'Z'], 5)
      break short_url unless Url.where(short_url: short_url).exists?
    end
  end

  def increment_click_count
    self.clicks_count = self.clicks_count + 1

    self.save
  end
end
