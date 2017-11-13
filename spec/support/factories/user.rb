# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    profile { |r| r.association :profile }
    role { %i[client admin].sample }
  end
end
