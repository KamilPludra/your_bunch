# encoding: utf-8

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Kamil Pludra",
                         email: "pludra@gmail.com",
                         password: "Pulsar123;",
                         password_confirmation: "Pulsar123;")
    admin.toggle!(:admin)


  end
end