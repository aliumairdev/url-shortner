# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { create(:url) }

  describe 'associations' do
    it { is_expected.to have_many(:clicks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:short_url) }
    it { is_expected.to validate_uniqueness_of(:short_url) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it 'is not valid when original URL is not right' do
      subject.original_url = 'bad_url'

      expect(subject).to_not be_valid
    end

    it 'is not valid when short URL is not right' do
      subject.short_url = 'bad_url'

      expect(subject).to_not be_valid
    end

    it 'validates short URL is present' do
      subject.short_url = nil

      expect(subject).to_not be_valid
    end
  end
end
