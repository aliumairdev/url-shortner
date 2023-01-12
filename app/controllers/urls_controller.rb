# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :set_url, only: %i[ show visit ]

  def index
    # recent 10 short urls
    @urls = Url.latest
    @url = Url.new
  end

  def create
    original_url = params[:url][:original_url]

    if url_valid?(original_url)
      @url = Url.new(url_params)
      @url.short_url = @url.generate_short_url

      if @url.save
        flash[:notice] = "created successfully"
      else
        flash[:notice] = @url.errors.full_messages
      end
    else
      flash[:notice] = "given url is invalid"
    end

    redirect_to urls_path
  end

  def show
    clicks = @url&.clicks&.from_this_month
    if clicks
      @daily_clicks = clicks.group('DATE(created_at)').count.map{|r| ["#{r[0].strftime('%D')}",r[1]]}

      @browsers_clicks = clicks.group(:browser).count.to_a

      @platform_clicks = clicks.group(:platform).count.to_a
    end
  end

  def visit
    user_platform = browser.platform.name
    user_browser = browser.name

    if @url
      Click.create!(platform: user_platform, browser: user_browser, url: @url)
      @url.increment_click_count

      redirect_to @url.original_url
    else
      render_404
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def set_url
    @url = Url.find_by(short_url: params[:url])
    if !@url
      raise ActiveRecord::RecordNotFound
    end
  end

  def url_valid?(url)
    if url =~ URI::regexp
      return true
    else
      return false
    end
  end
end
