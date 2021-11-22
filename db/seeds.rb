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
             start_time:   Time.zone.parse('2021-11-15 15:30:00'),
             end_time:     Time.zone.parse('2021-11-15 15:45:00'))

Work.create!(user_id:      user.id,
             user_name:    user.name,
             project_id:   project.id,
             project_name: project.name,
             project_code: project.code,
             content:      "制御開発",
             start_time:   Time.zone.parse('2021-11-15 8:30:00'),
             end_time:     Time.zone.parse('2021-11-15 10:30:00'))

Work.create!(user_id:      user.id,
             user_name:    user.name,
             project_id:   project.id,
             project_name: project.name,
             project_code: project.code,
             content:      "物体検出機能の開発",
             start_time:   Time.zone.parse('2021-11-16 10:30:00'),
             end_time:     Time.zone.parse('2021-11-16 11:30:00'))

Work.create!(user_id:      user.id,
             user_name:    user.name,
             project_id:   project.id,
             project_name: project.name,
             project_code: project.code,
             content:      "制御開発",
             start_time:   Time.zone.parse('2021-11-8 15:30:00'),
             end_time:     Time.zone.parse('2021-11-8 16:30:00'))