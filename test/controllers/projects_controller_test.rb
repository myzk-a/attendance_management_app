require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user    = users(:SYATYO)
    @nonadmin_user = users(:BUTYO)
  end

  test "should get new" do
    log_in_as(@admin_user)
    get project_signup_path
    assert_response :success
  end

  test "should get index" do
    log_in_as(@admin_user)
    get projects_path
    assert_response :success
  end

  test "should redirect new when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get project_signup_path
    assert_redirected_to root_url
  end

  test "should redirect new when not logged in" do
    get project_signup_path
    assert_redirected_to root_url
  end

  test "should redirect index when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get projects_path
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get projects_path
    assert_redirected_to root_url
  end

end