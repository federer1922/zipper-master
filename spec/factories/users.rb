# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
