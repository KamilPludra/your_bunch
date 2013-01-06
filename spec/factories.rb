# encoding: utf-8
FactoryGirl.define do
  factory :user do
    name     "Kamil Pludra"
    email    "pludra@gmail.com"
    password "pludi123"
    password_confirmation "pludi123"
  end
end