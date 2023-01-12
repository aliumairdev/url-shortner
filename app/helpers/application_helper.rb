# frozen_string_literal: true

module ApplicationHelper

  def format_date(date)
    date.strftime("%b %d, %Y")
  end
end
