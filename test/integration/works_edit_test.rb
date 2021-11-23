require 'test_helper'

class WorksEditTest < ActionDispatch::IntegrationTest
  def setup
    @butyo   = users(:BUTYO)
    @today   = DateTime.now.to_date
    @project = projects(:X)
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

  test "successful edit" do
    log_in_as(@butyo)
    get "/works/#{@work.id}/edit"
    assert_template "works/edit"
    assert_match "編集中", response.body
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
    assert_equal project.id,   @work.project_id
    assert_equal project.name, @work.project_name
    assert_equal project.code, @work.project_code
    assert_equal content,      @work.content
    follow_redirect!
    assert_not flash.empty?
    assert_match "14時30分", response.body
    assert_match "17時15分", response.body
    assert_match project.name, response.body
    assert_match project.code, response.body
    assert_match content, response.body
    assert_no_match "編集中", response.body
  end

  test "unsuccessful edit" do
    log_in_as(@butyo)
    get "/works/#{@work.id}/edit"
    assert_template "works/edit"
    assert_match "編集中", response.body
    project = projects(:Y)
    content = "テストコード修正"
    patch "/works/#{@work.id}/edit", params: { work: { user_id:       @butyo.id,
                                                       start_hours:   "14",
                                                       start_minutes: "30",
                                                       end_hours:     "13",
                                                       end_minutes:   "15",
                                                       project_id:    project.id,
                                                       content:       content } }
    assert_select "div#error_explanation"
    assert_template "works/edit"
    @work.reload
    assert_not_equal project.id,   @work.project_id
    assert_not_equal project.name, @work.project_name
    assert_not_equal project.code, @work.project_code
    assert_not_equal content,      @work.content
    assert_match "15時15分", response.body
    assert_match "16時15分", response.body
    assert_match @project.name, response.body
    assert_match @project.code, response.body
    assert_match "テストコード作成", response.body
    assert_match "編集中", response.body
  end

end
