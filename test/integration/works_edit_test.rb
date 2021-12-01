require 'test_helper'

class WorksEditTest < ActionDispatch::IntegrationTest
  def setup
    @butyo   = users(:BUTYO)
    @today   = DateTime.now.to_date
    @project = projects(:X)
    @butyo.works.create!( project_id: @project.id,
                          content:    "テストコード作成",
                          start_time: Time.zone.parse('2021-11-23 15:15:12'),
                          end_time:   Time.zone.parse('2021-11-23 16:15:12'))
    @work = @butyo.works.first
  end

  test "successful edit" do
    log_in_as(@butyo)
    get "/works/#{@work.id}/edit"
    assert_template "works/edit"
    assert_match "編集中", response.body
    project = projects(:Y)
    content = "テストコード修正"
    start_time = Time.zone.parse(@work.start_time.to_date.to_s + " " + "14:30:00")
    end_time   = Time.zone.parse(@work.start_time.to_date.to_s + " " + "17:15:00")
    patch "/works/#{@work.id}/edit", params: { work: { start_time: start_time,
                                                       end_time:   end_time,
                                                       project_id: project.id,
                                                       content:    content } }
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
    start_time = Time.zone.parse(@work.start_time.to_date.to_s + " " + "14:30:00")
    end_time   = Time.zone.parse(@work.start_time.to_date.to_s + " " + "13:15:00")
    patch "/works/#{@work.id}/edit", params: { work: { start_time: start_time,
                                                       end_time:   end_time,
                                                       project_id: project.id,
                                                       content:    content } }
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
