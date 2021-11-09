require 'test_helper'

class ProjectsIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:SYATYO)
    @project    = projects(:X)
  end

  test "index including pagination" do
    log_in_as(@admin_user)
    get projects_path
    assert_template 'projects/index'
    assert_select 'div.pagination'
    Project.paginate(page: 1).each do |project|
      assert_select 'a[href=?]', edit_project_path(project), text: '編集'
      assert_select 'a[href=?]', project_path(project), text: '削除'
    end
    assert_difference 'Project.count', -1 do
      delete project_path(@project)
    end
    assert_not flash.empty?
    assert_redirected_to projects_path
  end

end
