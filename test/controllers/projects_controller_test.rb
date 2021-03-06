require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user    = users(:SYATYO)
    @nonadmin_user = users(:BUTYO)
    @project       = projects(:X)
  end

  test "should get new when logged in admin user" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_response :success
  end

  test "should get index when logged in admin user" do
    log_in_as(@admin_user)
    get projects_path
    assert_response :success
  end

  test "should get edit when logged in admin user" do
    log_in_as(@admin_user)
    get edit_project_path(@project)
    assert_response :success
  end

  test "should redirect new when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get projects_signup_path
    assert_redirected_to root_url
  end

  test "should redirect new when not logged in" do
    get projects_signup_path
    assert_redirected_to login_url
  end

  test "should redirect index when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get projects_path
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get projects_path
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get edit_project_path(@project)
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get edit_project_path(@project)
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    assert_no_difference 'Project.count' do
      delete project_path(@project)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Project.count' do
      delete project_path(@project)
    end
    assert_redirected_to login_url
  end

  test "should redirect import when not logged in" do
    projects_csv = fixture_file_upload("/files/projects/valid_projects_sjis.csv", "text/csv")
    assert_no_difference 'Project.count' do
      post import_projects_path, params: { file: projects_csv }
    end
    assert_redirected_to login_url
  end

  test "should redirect import when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    projects_csv = fixture_file_upload("/files/projects/valid_projects_sjis.csv", "text/csv")
    assert_no_difference 'Project.count' do
      post import_projects_path, params: { file: projects_csv }
    end
    assert_redirected_to root_url
  end

end