# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

User.create(name: "Test Testing", email: "testing@test.com", password: "testing", password_confirmation: "testing", admin: true, activated: true)

99.times do
  User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "testing", password_confirmation: "testing", activated: true)
end
