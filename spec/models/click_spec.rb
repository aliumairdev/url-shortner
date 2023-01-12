# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  subject { create(:click) }

  describe 'associations' do
    it { is_expected.to belong_to(:url) }
  end

  describe 'validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it 'not valid when url_id is nil' do
      subject.url_id = nil

      expect(subject).to_not be_valid
    end
  end
end
