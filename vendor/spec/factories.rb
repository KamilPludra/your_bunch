# encoding: utf-8
FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Osoba #{n}" }
    sequence(:email) { |n| "osoba_#{n}@przyklad.com"}
    password "przyklad"
    password_confirmation "przyklad"


    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end