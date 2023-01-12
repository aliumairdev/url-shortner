# frozen_string_literal: true

class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

  def render_404
    render file: Rails.root.join('public/404.html'), status: :not_found
  end
end
