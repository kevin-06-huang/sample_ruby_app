# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# we added the next part in listing 9.39, and it simply specified a rake
# task for seeding the database with sample users in order to test its
# functionality
# create! is the same as create except it raises an exception for an
# invalid user rather than returning false

# in listing 9.51, we added the admin: true line to make the first seeded
# user an admin

User.create!(name:  "Kevin Huang",
             email: "kevincrazykid@gmail.com",
             password: "password",
             password_confirmation: "password",
             admin: true,
             # this part is added in listing 10.4 in order to initialize
             # the sample and test user in an activated state
             activated: true,
             activated_at: Time.zone.now)
             
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               # likewise this part is added in listing 10.4 in order to
               # initialize the user in an activated state
               activated: true,
               activated_at: Time.zone.now)
end

# this is added from listing 11.24 to generate seed data for micropost
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
# to seed our database, we type in the following command:
# $ bundle exec rake db:migrate:reset
# $ bundle exec rake db:seed