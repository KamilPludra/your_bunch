# encoding: utf-8

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Kamil Pludra",
                         email: "pludra@gmail.com",
                         password: "Pulsar123;",
                         password_confirmation: "Pulsar123;")
    admin.toggle!(:admin)

    99.times do |n|
      name  = Faker::Name.name
      email = "przyklad-#{n+1}@gmail.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end