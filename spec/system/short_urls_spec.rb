# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :headless_chrome
  end

  let(:url) { create(:url) }
  let(:google_url) { create(:url, short_url: 'GOOGL', original_url: 'https://www.google.com/') }

  describe 'index' do
    it 'shows a list of short urls' do
      visit root_path

      expect(page).to have_text('Create a new short URL')
    end
  end

  context 'with invalid params' do
    before do
      get '/urls'
    end

    it 'has 500 status code' do
      expect(response.status).to eq(200)
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      visit url_path(url.short_url)

      expect(page).to have_text(url.short_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')

        expect(page).to have_text("The page you were looking for doesn't exist")
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      it 'creates the short url' do
        visit '/'
        fill_in 'url[original_url]', with: 'https://www.google.com'
        find('button[type=submit]').click

        expect(page).to have_text('created successfully')
      end

      it 'redirects to the home page' do
        visit '/'
        fill_in 'url[original_url]', with: 'https://www.google.com'
        find('button[type=submit]').click

        expect(page).to have_text('Create a new short URL')
      end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit '/'
        fill_in 'url[original_url]', with: 'bad_url'
        find('button[type=submit]').click

        expect(page).to have_text('given url is invalid')
      end

      it 'redirects to the home page' do
        visit '/'
        fill_in 'url[original_url]', with: 'bad_url'
        find('button[type=submit]').click

        expect(page).to have_text('Create a new short URL')
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      visit visit_path(google_url.short_url)

      expect(page).to have_text('Google')
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')

        expect(page).to have_text("The page you were looking for doesn't exist")
      end
    end
  end
end
