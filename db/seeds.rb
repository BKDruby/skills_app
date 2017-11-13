# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create email: "admin@test.com", password: "12345678", role: :admin
User.create email: "client@test.com", password: "12345678"
10.times do
  User.create email: Faker::Internet.email,
              password: Faker::Internet.password,
              role: %i[client admin].sample,
              profile_attributes: {
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                phone: Faker::PhoneNumber.cell_phone
              }
end
