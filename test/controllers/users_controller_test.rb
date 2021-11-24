require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user           = users(:SYATYO)
    @other_user     = users(:BUTYO)
    @admin_user     = users(:SYATYO)
    @nonadmin_user  = users(:BUTYO)
    @nonadmin_user2 = users(:KATYO)
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should get new" do
    log_in_as(@admin_user)
    get signup_path
    assert_response :success
  end

  test "should get show" do
    log_in_as(@nonadmin_user)
    get user_path(@nonadmin_user)
    assert_response :success
    assert_template 'users/show'
  end

  test "should get show other user when logged in as admin user" do
    log_in_as(@admin_user)
    get user_path(@nonadmin_user)
    assert_response :success
    assert_template 'users/show'
  end

  test "should redirect signup when not admin_user" do
    log_in_as(@nonadmin_user)
    get signup_path
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true} }
    assert_not @other_user.reload.admin?
  end
  
  test "should redirect show when logged in as wrong user" do
    log_in_as(@nonadmin_user)
    get user_path(@nonadmin_user2)
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect import when not logged in" do
    users_csv = fixture_file_upload("files/users/valid_users_utf8.csv", "text/csv")
    assert_no_difference 'User.count' do
      post import_users_path, params: { file: users_csv }
    end
    assert_redirected_to login_url
  end

  test "should redirect import when logged in as nonadmin user" do
    log_in_as(@nonadmin_user)
    users_csv = fixture_file_upload("files/users/valid_users_utf8.csv", "text/csv")
    assert_no_difference 'User.count' do
      post import_users_path, params: { file: users_csv }
    end
    assert_redirected_to root_url
  end

end
