# frozen_string_literal: true

FactoryBot.define do
  factory :click do
    platform { 'macOS' }
    browser { 'Chrome' }

    association :url, factory: :url, strategy: :create
  end
end
