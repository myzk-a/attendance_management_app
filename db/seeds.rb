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

60.times do |n|
  name = "project_#{n}"
  code = "code_#{n}"
  Project.create!(name: name, code: code)
end

user = User.find_by(id: 2)
project = Project.first
Work.create!(user_id:      user.id,
             user_name:    user.name,
             project_id:   project.id,
             project_name: project.name,
             project_code: project.code,
             content:      "制御開発",
             start_time:   10.minutes.ago,
             end_time:     5.minutes.ago)

Work.create!(user_id:      user.id,
             user_name:    user.name,
             project_id:   project.id,
             project_name: project.name,
             project_code: project.code,
             content:      "制御開発",
             start_time:   180.minutes.ago,
             end_time:     120.minutes.ago)

start_time = DateTime.now - 6
end_time   = start_time + Rational("1/24")
Work.create!(user_id:      user.id,
             user_name:    user.name,
             project_id:   project.id,
             project_name: project.name,
             project_code: project.code,
             content:      "制御開発",
             start_time:   start_time,
             end_time:     end_time)