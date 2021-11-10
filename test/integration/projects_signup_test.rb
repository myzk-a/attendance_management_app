require 'test_helper'

class ProjectsSignupTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:SYATYO)
  end

  test "invalid signup information" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_no_difference 'Project.count' do
      post projects_signup_path, params: { project: { name: "", code: "" } }
    end
    assert_template 'projects/new'
  end

  test "valid signup information" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_difference 'Project.count', 1 do
      post projects_signup_path, params: { project: { name: "新規プロジェクト", code: "new" } }
    end
    follow_redirect!
    assert_template 'projects/index'
    assert_not flash.empty?
  end

end