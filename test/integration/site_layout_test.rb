require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
   @admin_user = users(:SYATYO)
   @nonadmin_user = users(:BUTYO)
  end

  test "layout links before login" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path,                   count: 2
    assert_select "a[href=?]", users_path,                  count: 0
    assert_select "a[href=?]", signup_path,                 count: 0
    assert_select "a[href=?]", projects_path,               count: 0
    assert_select "a[href=?]", project_signup_path,         count: 0
    assert_select "a[href=?]", edit_user_path(@admin_user), count: 0
    assert_select "a[href=?]", logout_path,                 count: 0
    assert_select "a[href=?]", login_path
    assert_select "title", full_title("ホーム")
  end

  test "layout links after login as admin_user" do
    log_in_as(@admin_user)
    get root_path
    assert_redirected_to @admin_user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", root_path,                   count: 0
    assert_select "a[href=?]", users_path,                  count: 2
    assert_select "a[href=?]", signup_path,                 count: 2
    assert_select "a[href=?]", projects_path,               count: 2
    assert_select "a[href=?]", project_signup_path,         count: 2
    assert_select "a[href=?]", edit_user_path(@admin_user), count: 2
    assert_select "a[href=?]", logout_path,                 count: 1
    assert_select "a[href=?]", login_path,                  count: 0
    assert_select "title", full_title("#{@admin_user.name}")
  end

  test "layout links after login as nonadmin_user" do
    log_in_as(@nonadmin_user)
    get root_path
    assert_redirected_to @nonadmin_user
    follow_redirect!
    assert_template ('users/show')
    assert_select "a[href=?]", root_path,                      count: 0
    assert_select "a[href=?]", users_path,                     count: 0
    assert_select "a[href=?]", user_path(@nonadmin_user),      count: 3
    assert_select "a[href=?]", signup_path,                    count: 0
    assert_select "a[href=?]", projects_path,                  count: 0
    assert_select "a[href=?]", project_signup_path,            count: 0
    assert_select "a[href=?]", edit_user_path(@nonadmin_user), count: 1
    assert_select "a[href=?]", logout_path,                    count: 1
    assert_select "a[href=?]", login_path,                     count: 0
    assert_select "title", full_title("#{@nonadmin_user.name}")
  end

end
