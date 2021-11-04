User.create!(name:  "管理者",
             email: "a_admin@as-mobi.com",
             password:              "asmobi",
             password_confirmation: "asmobi",
             admin: true)

60.times do |n|
  name  = Faker::Name.name
  email = "#{n}_example@as-mobi.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end