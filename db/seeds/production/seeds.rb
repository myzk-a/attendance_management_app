User.create!(name: "管理者",
             email:                 ENV.fetch("ADMIN_USER_DEFAULT_EMAIL"){""},
             password:              ENV.fetch("ADMIN_USER_DEFAULT_PASSWORD"){""},
             password_confirmation: ENV.fetch("ADMIN_USER_DEFAULT_PASSWORD"){""},
             admin: true)