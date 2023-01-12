# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

  scope :from_this_month, lambda { where("clicks.created_at > ? AND clicks.created_at < ?", Time.now.beginning_of_month, Time.now.end_of_month) }
end
