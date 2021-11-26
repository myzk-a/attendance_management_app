require 'test_helper'

class WorksSearchTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:SYATYO)
    @butyo      = users(:BUTYO)
    @syunin     = users(:SYUNIN)
    @syain1     = users(:user_1)
    @project_x  = projects(:X)
    @project_y  = projects(:Y)
    set_works
  end

  test "invalid search information" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "2021",
                                               month: "",
                                               user_name_pull_down: "",
                                               user_name: "",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_not flash.empty?
    assert_no_match "抽出結果", response.body
  end

  test "search by year and month" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "2021",
                                               month: "11",
                                               user_name_pull_down: "",
                                               user_name: "",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_match "5時間15分", response.body
    assert_select "table"
    assert_match    "11月20日", response.body
    assert_no_match "12月20日", response.body
    assert_match    "11月21日", response.body
    assert_no_match "12月21日", response.body
    assert_match    "11月22日", response.body
    assert_no_match "12月22日", response.body
    assert_match    "11月23日", response.body
    assert_no_match "12月23日", response.body
    assert_match "<td>#{@butyo.name}</td>",     response.body
    assert_match "<td>#{@syunin.name}</td>",    response.body
    assert_match "<td>#{@project_x.name}</td>", response.body
    assert_match "<td>#{@project_x.code}</td>", response.body
    assert_match "<td>#{@project_y.name}</td>", response.body
    assert_match "<td>#{@project_y.code}</td>", response.body
  end

  test "search by name pull down" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "",
                                               month: "",
                                               user_name_pull_down: @butyo.name,
                                               user_name: "",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_match "4時間0分", response.body
    assert_select "table"
    assert_match    "11月20日", response.body
    assert_match    "12月20日", response.body
    assert_match    "11月21日", response.body
    assert_match    "12月21日", response.body
    assert_no_match "11月22日", response.body
    assert_no_match "12月22日", response.body
    assert_no_match "11月23日", response.body
    assert_no_match "12月23日", response.body
    assert_match    "<td>#{@butyo.name}</td>",     response.body
    assert_no_match "<td>#{@syunin.name}</td>",    response.body
    assert_match    "<td>#{@project_x.name}</td>", response.body
    assert_match    "<td>#{@project_x.code}</td>", response.body
    assert_match    "<td>#{@project_y.name}</td>", response.body
    assert_match    "<td>#{@project_y.code}</td>", response.body
  end

  test "search by name include half width space" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "",
                                               month: "",
                                               user_name_pull_down: "",
                                               user_name: "部 長",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_match "4時間0分", response.body
    assert_select "table"
    assert_match    "11月20日", response.body
    assert_match    "12月20日", response.body
    assert_match    "11月21日", response.body
    assert_match    "12月21日", response.body
    assert_no_match "11月22日", response.body
    assert_no_match "12月22日", response.body
    assert_no_match "11月23日", response.body
    assert_no_match "12月23日", response.body
    assert_match    "<td>#{@butyo.name}</td>",     response.body
    assert_no_match "<td>#{@syunin.name}</td>",    response.body
    assert_match    "<td>#{@project_x.name}</td>", response.body
    assert_match    "<td>#{@project_x.code}</td>", response.body
    assert_match    "<td>#{@project_y.name}</td>", response.body
    assert_match    "<td>#{@project_y.code}</td>", response.body
  end

  test "search by name include full width space" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "",
                                               month: "",
                                               user_name_pull_down: "",
                                               user_name: "部　長",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_match "4時間0分", response.body
    assert_select "table"
    assert_match    "11月20日", response.body
    assert_match    "12月20日", response.body
    assert_match    "11月21日", response.body
    assert_match    "12月21日", response.body
    assert_no_match "11月22日", response.body
    assert_no_match "12月22日", response.body
    assert_no_match "11月23日", response.body
    assert_no_match "12月23日", response.body
    assert_match    "<td>#{@butyo.name}</td>",     response.body
    assert_no_match "<td>#{@syunin.name}</td>",    response.body
    assert_match    "<td>#{@project_x.name}</td>", response.body
    assert_match    "<td>#{@project_x.code}</td>", response.body
    assert_match    "<td>#{@project_y.name}</td>", response.body
    assert_match    "<td>#{@project_y.code}</td>", response.body
  end

  test "search by name without space" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "",
                                               month: "",
                                               user_name_pull_down: "",
                                               user_name: "社員1",
                                               project_name_pull_down: "",
                                               project_name: "" } }
    assert_match    "<td>#{@syain1.name}</td>",     response.body
  end

  test "search by project" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "",
                                               month: "",
                                               user_name_pull_down: "",
                                               user_name: "",
                                               project_name_pull_down: @project_x.name,
                                               project_name: "" } }
    assert_match "4時間30分", response.body
    assert_select "table"
    assert_match    "11月20日", response.body
    assert_match    "12月20日", response.body
    assert_no_match "11月21日", response.body
    assert_no_match "12月21日", response.body
    assert_match    "11月22日", response.body
    assert_match    "12月22日", response.body
    assert_no_match "11月23日", response.body
    assert_no_match "12月23日", response.body
    assert_match    "<td>#{@butyo.name}</td>",     response.body
    assert_match    "<td>#{@syunin.name}</td>",    response.body
    assert_match    "<td>#{@project_x.name}</td>", response.body
    assert_match    "<td>#{@project_x.code}</td>", response.body
    assert_no_match "<td>#{@project_y.name}</td>", response.body
    assert_no_match "<td>#{@project_y.code}</td>", response.body
  end

  test "search by year and month and name and project" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "2021",
                                               month: "11",
                                               user_name_pull_down: @butyo.name,
                                               user_name: "",
                                               project_name_pull_down: @project_x.name,
                                               project_name: "" } }
    assert_match "1時間30分", response.body
    assert_select "table"
    assert_match    "11月20日", response.body
    assert_no_match "12月20日", response.body
    assert_no_match "11月21日", response.body
    assert_no_match "12月21日", response.body
    assert_no_match "11月22日", response.body
    assert_no_match "12月22日", response.body
    assert_no_match "11月23日", response.body
    assert_no_match "12月23日", response.body
    assert_match    "<td>#{@butyo.name}</td>",     response.body
    assert_no_match "<td>#{@syunin.name}</td>",    response.body
    assert_match    "<td>#{@project_x.name}</td>", response.body
    assert_match    "<td>#{@project_x.code}</td>", response.body
    assert_no_match "<td>#{@project_y.name}</td>", response.body
    assert_no_match "<td>#{@project_y.code}</td>", response.body
  end

  test "search by year and month project" do
    log_in_as(@admin_user)
    get works_search_path
    assert_template "works/search"
    assert_no_match "抽出結果", response.body
    get works_search_path, params: { search: { searching: true,
                                               year: "2021",
                                               month: "12",
                                               user_name_pull_down: "",
                                               user_name: "",
                                               project_name_pull_down: @project_y.name,
                                               project_name: "" } }
    assert_match "1時間0分", response.body
    assert_select "table"
    assert_no_match "11月20日", response.body
    assert_no_match "12月20日", response.body
    assert_no_match "11月21日", response.body
    assert_match    "12月21日", response.body
    assert_no_match "11月22日", response.body
    assert_no_match "12月22日", response.body
    assert_no_match "11月23日", response.body
    assert_match    "12月23日", response.body
    assert_match    "<td>#{@butyo.name}</td>",     response.body
    assert_match    "<td>#{@syunin.name}</td>",    response.body
    assert_no_match "<td>#{@project_x.name}</td>", response.body
    assert_no_match "<td>#{@project_x.code}</td>", response.body
    assert_match    "<td>#{@project_y.name}</td>", response.body
    assert_match    "<td>#{@project_y.code}</td>", response.body
  end

  private

    def set_works
      butyo     = users(:BUTYO)
      syunin    = users(:SYUNIN)
      syain1    = users(:user_1)
      project_x = projects(:X)
      project_y = projects(:Y)
      #部長の工数
      Work.create( user_id:      butyo.id,
                   user_name:    butyo.name,
                   project_id:   project_x.id,
                   project_name: project_x.name,
                   project_code: project_x.code,
                   content:      "部長、プロジェクトX、11月",
                   start_time:   Time.zone.parse('2021-11-20 9:00:00'),
                   end_time:     Time.zone.parse('2021-11-20 10:30:00') )
      Work.create( user_id:      butyo.id,
                   user_name:    butyo.name,
                   project_id:   project_x.id,
                   project_name: project_x.name,
                   project_code: project_x.code,
                   content:      "部長、プロジェクトX、12月",
                   start_time:   Time.zone.parse('2021-12-20 9:00:00'),
                   end_time:     Time.zone.parse('2021-12-20 9:45:00') )
      Work.create( user_id:      butyo.id,
                   user_name:    butyo.name,
                   project_id:   project_y.id,
                   project_name: project_y.name,
                   project_code: project_y.code,
                   content:      "部長、プロジェクトY、11月",
                   start_time:   Time.zone.parse('2021-11-21 9:00:00'),
                   end_time:     Time.zone.parse('2021-11-21 10:15:00') )
      Work.create( user_id:      butyo.id,
                   user_name:    butyo.name,
                   project_id:   project_y.id,
                   project_name: project_y.name,
                   project_code: project_y.code,
                   content:      "部長、プロジェクトY、12月",
                   start_time:   Time.zone.parse('2021-12-21 9:00:00'),
                   end_time:     Time.zone.parse('2021-12-21 9:30:00') )
      #主任の工数
      Work.create( user_id:      syunin.id,
                   user_name:    syunin.name,
                   project_id:   project_x.id,
                   project_name: project_x.name,
                   project_code: project_x.code,
                   content:      "主任、プロジェクトX、11月",
                   start_time:   Time.zone.parse('2021-11-22 9:00:00'),
                   end_time:     Time.zone.parse('2021-11-22 9:45:00') )
      Work.create( user_id:      syunin.id,
                   user_name:    syunin.name,
                   project_id:   project_x.id,
                   project_name: project_x.name,
                   project_code: project_x.code,
                   content:      "主任、プロジェクトX、12月",
                   start_time:   Time.zone.parse('2021-12-22 9:00:00'),
                   end_time:     Time.zone.parse('2021-12-22 10:30:00') )
      Work.create( user_id:      syunin.id,
                   user_name:    syunin.name,
                   project_id:   project_y.id,
                   project_name: project_y.name,
                   project_code: project_y.code,
                   content:      "主任、プロジェクトY、11月",
                   start_time:   Time.zone.parse('2021-11-23 9:00:00'),
                   end_time:     Time.zone.parse('2021-11-23 10:45:00') )
      Work.create( user_id:      syunin.id,
                   user_name:    syunin.name,
                   project_id:   project_y.id,
                   project_name: project_y.name,
                   project_code: project_y.code,
                   content:      "主任、プロジェクトY、12月",
                   start_time:   Time.zone.parse('2021-12-23 9:00:00'),
                   end_time:     Time.zone.parse('2021-12-23 9:30:00') )
      #社員1の工数
      Work.create( user_id:      syain1.id,
                   user_name:    syain1.name,
                   project_id:   project_y.id,
                   project_name: project_y.name,
                   project_code: project_y.code,
                   content:      "社員1、プロジェクトY、10月",
                   start_time:   Time.zone.parse('2021-10-23 9:00:00'),
                   end_time:     Time.zone.parse('2021-10-23 9:30:00') )
    end

end
