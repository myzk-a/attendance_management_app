require 'test_helper'

class ProjectsEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user    = users(:SYATYO)
    @nonadmin_user = users(:BUTYO)
    @project       = projects(:X)
  end

  test "unsuccessful edit" do
    log_in_as(@admin_user)
    get edit_project_path(@project)
    assert_template 'projects/edit'
    name = "   "
    code = "   "
    patch project_path(@project), params: { project: { name: name, code: code } }
    @project.reload
    assert_not_equal name, @project.name
    assert_not_equal code, @project.code
    assert_template 'projects/edit'
  end

  test "successful edit" do
    log_in_as(@admin_user)
    get edit_project_path(@project)
    assert_template 'projects/edit'
    code = "XX"
    patch project_path(@project), params: { project: { code: code } }
    assert_not flash.empty?
    assert_redirected_to projects_path
    @project.reload
    assert_equal code, @project.code
  end

  test "should redirect update when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    name = "project XX"
    code = "XX"
    patch project_path(@project), params: { project: { name: name,  code: code } }
    assert flash.empty?
    @project.reload
    assert_not_equal name, @project.name
    assert_not_equal code, @project.code
    assert_redirected_to root_url
  end
  
  test "should redirect update when not logged in" do
    name = "project XX"
    code = "XX"
    patch project_path(@project), params: { project: { name: name,  code: code } }
    assert_not flash.empty?
    @project.reload
    assert_not_equal name, @project.name
    assert_not_equal code, @project.code
    assert_redirected_to login_url
  end 

end
