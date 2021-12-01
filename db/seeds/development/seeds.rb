User.create!(name: "管理者",
             email:                 ENV.fetch("ADMIN_USER_DEFAULT_EMAIL"){""},
             password:              ENV.fetch("ADMIN_USER_DEFAULT_PASSWORD"){""},
             password_confirmation: ENV.fetch("ADMIN_USER_DEFAULT_PASSWORD"){""},
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

60.times do |n|
  name = "project_#{n}"
  code = "code_#{n}"
  Project.create!(name: name, code: code)
end

user_1  = User.find_by(id: 2)
project = Project.first
user_1.works.create!( project_id:   project.id,
                     content:      "制御開発",
                     start_time:   Time.zone.parse('2021-11-15 15:30:00'),
                     end_time:     Time.zone.parse('2021-11-15 15:45:00'))

user_2  = User.find_by(id: 3)
project = Project.first
user_2.works.create!( project_id:   project.id,
                      content:      "制御開発",
                      start_time:   Time.zone.parse('2021-11-15 15:30:00'),
                      end_time:     Time.zone.parse('2021-11-15 15:45:00'))