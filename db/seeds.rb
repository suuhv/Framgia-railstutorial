User.create! name:  "Example User",
  email: "suu@123.com",
  password: "123123",
  password_confirmation: "123123",
  is_admin: true

99.times do |n|
  name = Faker::Name.name
  email = "suu#{n+1}@123.com"
  password = "123123"
  User.create! name: name,
    email: email,
    password: password,
    password_confirmation: password
end
