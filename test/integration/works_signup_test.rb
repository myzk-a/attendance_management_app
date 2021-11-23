require 'test_helper'

class WorksSignupTest < ActionDispatch::IntegrationTest
  def setup
    @butyo   = users(:BUTYO)
    @today   = DateTime.now.to_date
    @project = projects(:X)
  end

  test "invalid signup information" do
    log_in_as(@butyo)
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_template "works/new"
    assert_no_difference 'Work.count' do
      post "/works/#{@butyo.id}/#{@today}/new", params: { work: { user_id:       "",
                                                                  start_hours:   "",
                                                                  start_minutes: "",
                                                                  end_hours:     "",
                                                                  end_minutes:   "",
                                                                  project_id:    "",
                                                                  content:       "" } }
    end
    assert_select "div#error_explanation"
    assert_template "works/new"
  end

  test "valid signup information" do
    log_in_as(@butyo)
    get "/works/#{@butyo.id}/#{@today}/new"
    assert_template "works/new"
    assert_difference 'Work.count', 1 do
      post "/works/#{@butyo.id}/#{@today}/new", params: { work: { user_id:       @butyo.id,
                                                                  start_hours:   "9",
                                                                  start_minutes: "0",
                                                                  end_hours:     "12",
                                                                  end_minutes:   "30",
                                                                  project_id:    @project.id,
                                                                  content:       "test" } }
    end
    follow_redirect!
    assert_template "works/new"
    assert_not flash.empty?
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
