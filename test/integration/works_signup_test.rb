require 'test_helper'

class WorksSignupTest < ActionDispatch::IntegrationTest
  def setup
    @butyo   = users(:BUTYO)
    @today   = Time.zone.parse('2021-11-23 15:15:12').to_date
    @project = projects(:X)
  end

  test "invalid signup information" do
    log_in_as(@butyo)
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_template "works/new"
    assert_no_difference 'Work.count' do
      post "/works/#{@butyo.id}/#{@today}/new", params: { form_work_collection: { works_attributes: { "0" => { user_id:    "",
                                                                                                               start_time: "",
                                                                                                               end_time:   "",
                                                                                                               project_id: "",
                                                                                                               content:    "",
                                                                                                               signup:     true} } } }
    end
    assert_select "div#error_explanation"
    assert_template "works/new"
  end

  test "valid signup information" do
    log_in_as(@butyo)
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_template "works/new"
    start_time = Time.zone.parse('2021-11-23 9:00:00')
    end_time   = Time.zone.parse('2021-11-23 12:30:00')
    assert_difference 'Work.count', 1 do
      post "/works/#{@butyo.id}/#{@today}/new", params: { form_work_collection: { works_attributes: { "0" => { user_id:    @butyo.id,
                                                                                                               start_time: start_time,
                                                                                                               end_time:   end_time,
                                                                                                               project_id: @project.id,
                                                                                                               content:    "test",
                                                                                                               signup:     true} } } }
    end
    follow_redirect!
    assert_template "works/new"
    assert_not flash.empty?
    assert_match @butyo.name, response.body
    assert_match "09時00分", response.body
    assert_match "12時30分", response.body
    assert_match @project.name, response.body
    assert_match @project.code, response.body
    assert_match "test", response.body
    assert_match "編集", response.body
    assert_match "削除", response.body
    work = Work.first
    assert_select "a[href=?]", "/works/#{work.id}/edit", count: 1
    assert_select "a[href=?]", "/works/#{work.id}", count: 1
  end

end
