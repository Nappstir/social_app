# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

User.create(name: "Test Testing", email: "testing@test.com", password: "testing", password_confirmation: "testing", admin: true, activated: true)

50.times do
  User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "testing", password_confirmation: "testing", activated: true)
end

# take the first 6 users from database & create microposts
users = User.order(:created_at).take(6)
15.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

users = User.all
user = User.first
following = users[20..45]
followers = users[10..50]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }