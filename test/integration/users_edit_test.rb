require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:SYATYO)
    @admin_user = users(:SYATYO)
    @nonadmin_user = users(:BUTYO)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
  
  test "edit other_user as admin_user" do
    log_in_as(@admin_user)
    get edit_user_path(@nonadmin_user)
    assert_template 'users/edit'
    name = "foo bar"
    email ="foo_bar@as-mobi.com"
    email_before_update = @nonadmin_user.email
    password_digest_before_update = @nonadmin_user.password_digest
    patch user_path(@nonadmin_user), params: { user: { name:  name,
                                              email: email,
                                              password:              "foobar",
                                              password_confirmation: "foobar" } }
    assert_not flash.empty?
    assert_redirected_to @nonadmin_user
    @nonadmin_user.reload
    assert_equal name, @nonadmin_user.name
    assert_equal email_before_update, @nonadmin_user.email
    assert_equal password_digest_before_update, @nonadmin_user.password_digest
  end

  test "edit myself as admin_user" do
    log_in_as(@admin_user)
    get edit_user_path(@admin_user)
    assert_template 'users/edit'
    name = "foo bar"
    name_before_update = @admin_user.name
    email ="foo_bar@as-mobi.com"
    password_digest_before_update = @admin_user.password_digest
    patch user_path(@admin_user), params: { user: { name:  name,
                                            email: email,
                                            password:              "foobar",
                                            password_confirmation: "foobar" } }
    assert_not flash.empty?
    assert_redirected_to @admin_user
    @admin_user.reload
    assert_equal name_before_update, @admin_user.name
    assert_equal email, @admin_user.email
    assert_not_equal password_digest_before_update, @admin_user.password_digest
  end

  test "edit myself as nonadmin_user" do
    log_in_as(@nonadmin_user)
    get edit_user_path(@nonadmin_user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    name_before_update = @nonadmin_user.name
    email = "f_foo@as-mobi.com"
    email_before_update = @nonadmin_user.email
    password_digest_before_update = @nonadmin_user.password_digest
    patch user_path(@nonadmin_user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @nonadmin_user
    @nonadmin_user.reload
    assert_equal name_before_update,  @nonadmin_user.name
    assert_equal email_before_update, @nonadmin_user.email
    assert_equal password_digest_before_update, @nonadmin_user.password_digest
    patch user_path(@nonadmin_user), params: { user: { name:  name,
                                              email: email,
                                              password:              "foobar",
                                              password_confirmation: "foobar" } }
    assert_not flash.empty?
    assert_redirected_to @nonadmin_user
    @nonadmin_user.reload
    assert_not_equal password_digest_before_update, @nonadmin_user.password_digest
  end
  
  test "edit admin_user as nonadmin_user" do
    log_in_as(@nonadmin_user)
    get edit_user_path(@admin_user)
    assert_redirected_to root_url
    name  = "Foo Bar"
    name_before_update = @admin_user.name
    email = "f_foo@as-mobi.com"
    email_before_update = @admin_user.email
    password_digest_before_update = @admin_user.password_digest
    patch user_path(@nonadmin_user), params: { user: { name:  name,
                                              email: email,
                                              password:              "foobar",
                                              password_confirmation: "foobar" } }
    @admin_user.reload
    assert_equal name_before_update, @admin_user.name
    assert_equal email_before_update, @admin_user.email
    assert_equal password_digest_before_update, @admin_user.password_digest
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@nonadmin_user)
    log_in_as(@nonadmin_user)
    assert_redirected_to edit_user_url(@nonadmin_user)
    name  = "Foo Bar"
    email = "f_foo@as-mobi.com"
    patch user_path(@nonadmin_user), params: { user: { name:  name,
                                              email: email,
                                              password:              "foobar",
                                              password_confirmation: "foobar" } }
    assert_not flash.empty?
    assert_redirected_to @nonadmin_user
    @user.reload
    assert_not_equal name,  @nonadmin_user.name
    assert_not_equal email, @nonadmin_user.email
  end
  
end
