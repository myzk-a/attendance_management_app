require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:SYATYO)
  end

  test "invalid signup information" do
    log_in_as(@admin_user)
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    end
    assert_select "div#error_explanation"
    assert_template 'users/new'
    assert_match "type=\"password\"", response.body
  end
  
  test "valid signup information" do
    log_in_as(@admin_user)
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "u_user@as-mobi.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end

  test "valid sign up information via valid csv" do
    log_in_as(@admin_user)
    get signup_path
    assert_template 'users/new'
    assert_match "<label for=\"file\">", response.body
    assert_match "<input accept=\".csv\" ", response.body
    #文字コードがshift jisの場合
    users_csv = fixture_file_upload("files/users/valid_users_sjis.csv", "text/csv")
    assert_difference 'User.count', 1 do
      post import_users_path, params: { file: users_csv }
    end
    follow_redirect!
    assert_not flash[:success].empty?
    assert flash[:danger].blank?
    assert_template 'users/index'
    #文字コードがutf-8の場合
    users_csv = fixture_file_upload("files/users/valid_users_utf8.csv", "text/csv")
    assert_difference 'User.count', 1 do
      post import_users_path, params: { file: users_csv }
    end
    follow_redirect!
    assert_not flash[:success].empty?
    assert flash[:danger].blank?
    assert_template 'users/index'
    #文字コードがBOM付きutf-8の場合(レコードを二つ記入)
    users_csv = fixture_file_upload("files/users/valid_users_utf8_with_BOM.csv", "text/csv")
    assert_difference 'User.count', 2 do
      post import_users_path, params: { file: users_csv }
    end
    follow_redirect!
    assert_not flash[:success].empty?
    assert flash[:danger].blank?
    assert_template 'users/index'
  end

  test "invalid sign up information via invalid extension file" do
    log_in_as(@admin_user)
    get signup_path
    assert_template 'users/new'
    users_txt = fixture_file_upload("/files/users/valid_users_utf8.txt", "text/plain")
    assert_no_difference 'User.count' do
      post import_users_path, params: { file: users_txt }
    end
    follow_redirect!
    assert_not flash[:danger].empty?
    assert flash[:success].blank?
    assert_template 'users/new'
    assert_match "type=\"password\"", response.body
  end

  test "invalid sign up information when not selected csv file" do
    log_in_as(@admin_user)
    get signup_path
    assert_template 'users/new'
    users_csv = nil
    assert_no_difference 'User.count' do
      post import_users_path, params: { file: users_csv }
    end
    follow_redirect!
    assert_not flash[:danger].empty?
    assert flash[:success].blank?
    assert_template 'users/new'
    assert_match "type=\"password\"", response.body
  end

end
