require 'test_helper'

class WorksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:SYATYO)
    @butyo      = users(:BUTYO)
    @syunin     = users(:SYUNIN)
    @today      = DateTime.now.to_date
    @project    = projects(:X)
    Work.create( user_id:      @butyo.id,
                 user_name:    @butyo.name,
                 project_id:   @project.id,
                 project_name: @project.name,
                 project_code: @project.code,
                 content:      "テストコード作成",
                 start_time:   Time.zone.parse('2021-11-23 15:15:12'),
                 end_time:     Time.zone.parse('2021-11-23 16:15:12'))
    @work = Work.first
  end

  test "should get new when logged in correct user" do
    log_in_as(@butyo)
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_response :success
  end

  test "should get show when logged in admin user" do
    log_in_as(@admin_user)
    get "/works/#{@butyo.id}/#{@today}"
    assert_response :success
  end

  test "should destroy when logged in correct user" do
    log_in_as(@butyo)
    assert_difference 'Work.count', -1 do
      delete "/works/#{@work.id}"
    end
    assert_not flash.empty?
    assert_redirected_to "/works/#{@butyo.id}/2021-11-23/new"
    assert_no_match "登録内容", response.body
  end

  test "should get search when loggged in admin user" do
    log_in_as(@admin_user)
    get works_search_path
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_redirected_to login_url
  end

  test "should redirect new when logged in admin user" do
    log_in_as(@admin_user)
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_redirected_to root_url
  end

  test "should redirect new when logged in wrong user" do
    log_in_as(@syunin)
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_redirected_to root_url
  end

  test "should redirect show when not logged in" do
    get "/works/#{@butyo.id}/#{@today}"
    assert_redirected_to login_url
  end

  test "should redirect show when logged in nonadmin user" do
    log_in_as(@butyo)
    get "/works/#{@butyo.id}/#{@today}"
    assert_redirected_to root_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Work.count' do
      post "/works/#{@butyo.id}/#{@today}/new", params: { work: { user_id:       @butyo.id,
                                                                  start_hours:   "9",
                                                                  start_minutes: "0",
                                                                  end_hours:     "12",
                                                                  end_minutes:   "30",
                                                                  project_id:    @project.id,
                                                                  content:       "test" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect create when logged in admin user" do
    log_in_as(@admin_user)
    assert_no_difference 'Work.count' do
      post "/works/#{@butyo.id}/#{@today}/new", params: { work: { user_id:       @butyo.id,
                                                                  start_hours:   "9",
                                                                  start_minutes: "0",
                                                                  end_hours:     "12",
                                                                  end_minutes:   "30",
                                                                  project_id:    @project.id,
                                                                  content:       "test" } }
    end
    assert_redirected_to root_url
  end

  test "should redirect create when logged in wrong user" do
    log_in_as(@syunin)
    assert_no_difference 'Work.count' do
      post "/works/#{@butyo.id}/#{@today}/new", params: { work: { user_id:       @syunin.id,
                                                                  start_hours:   "9",
                                                                  start_minutes: "0",
                                                                  end_hours:     "12",
                                                                  end_minutes:   "30",
                                                                  project_id:    @project.id,
                                                                  content:       "test" } }
    end
    assert_redirected_to root_url
    assert_no_difference 'Work.count' do
      post "/works/#{@butyo.id}/#{@today}/new", params: { work: { user_id:       @butyo.id,
                                                                  start_hours:   "9",
                                                                  start_minutes: "0",
                                                                  end_hours:     "12",
                                                                  end_minutes:   "30",
                                                                  project_id:    @project.id,
                                                                  content:       "test" } }
    end
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get "/works/#{@work.id}/edit"
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in admin user" do
    log_in_as(@admin_user)
    get "/works/#{@work.id}/edit"
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in wrong user" do
    log_in_as(@syunin)
    get "/works/#{@work.id}/edit"
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    project = projects(:Y)
    content = "テストコード修正"
    patch "/works/#{@work.id}/edit", params: { work: { user_id:       @butyo.id,
                                                       start_hours:   "14",
                                                       start_minutes: "30",
                                                       end_hours:     "17",
                                                       end_minutes:   "15",
                                                       project_id:    project.id,
                                                       content:       content } }
    @work.reload
    assert_not_equal project.id,   @work.project_id
    assert_not_equal project.name, @work.project_name
    assert_not_equal project.code, @work.project_code
    assert_not_equal content,      @work.content
    assert_redirected_to login_url
  end

  test "should redirect update when logged in admin user" do
    log_in_as(@admin_user)
    project = projects(:Y)
    content = "テストコード修正"
    patch "/works/#{@work.id}/edit", params: { work: { user_id:       @butyo.id,
                                                       start_hours:   "14",
                                                       start_minutes: "30",
                                                       end_hours:     "17",
                                                       end_minutes:   "15",
                                                       project_id:    project.id,
                                                       content:       content } }
    @work.reload
    assert_not_equal project.id,   @work.project_id
    assert_not_equal project.name, @work.project_name
    assert_not_equal project.code, @work.project_code
    assert_not_equal content,      @work.content
    assert_redirected_to root_url
    follow_redirect!
    assert flash.empty?
  end

  test "should redirect update when logged in wrong user" do
    log_in_as(@syunin)
    project = projects(:Y)
    content = "テストコード修正"
    patch "/works/#{@work.id}/edit", params: { work: { user_id:       @butyo.id,
                                                       start_hours:   "14",
                                                       start_minutes: "30",
                                                       end_hours:     "17",
                                                       end_minutes:   "15",
                                                       project_id:    project.id,
                                                       content:       content } }
    @work.reload
    assert_not_equal project.id,   @work.project_id
    assert_not_equal project.name, @work.project_name
    assert_not_equal project.code, @work.project_code
    assert_not_equal content,      @work.content
    assert_redirected_to root_url
    follow_redirect!
    assert flash.empty?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Work.count' do
      delete "/works/#{@work.id}"
    end
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
  end

  test "should redirect destroy when logged in admin user" do
    log_in_as(@admin_user)
    assert_no_difference 'Work.count' do
      delete "/works/#{@work.id}"
    end
    assert_redirected_to root_url
    assert flash.empty?
  end

  test "should redirect destroy when logged in wrong user" do
    log_in_as(@syunin)
    assert_no_difference 'Work.count' do
      delete "/works/#{@work.id}"
    end
    assert_redirected_to root_url
    assert flash.empty?
  end

  test "should redirect search when not logged in" do
    get works_search_path
    assert_redirected_to login_url
  end

  test "should redirect search when logged in nondamin user" do
    log_in_as(@butyo)
    get works_search_path
    assert_redirected_to root_url
  end

  test "should redirect search with search item when not logged in" do
    get works_search_path, params: { search: { searching: true,
                                               year: "2021",
                                               month: "11",
                                               user_name_pull_down: "",
                                               user_name: "",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_no_match "抽出結果", response.body
    assert_redirected_to login_url
  end

  test "should redirect search with search item when logged in nonadmin user" do
    log_in_as(@butyo)
    get works_search_path, params: { search: { searching: true,
                                               year: "2021",
                                               month: "11",
                                               user_name_pull_down: "",
                                               user_name: "",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_no_match "抽出結果", response.body
    assert_redirected_to root_url
  end

end
