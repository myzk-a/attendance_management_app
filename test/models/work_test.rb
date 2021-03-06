require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  def setup
    @user    = users(:BUTYO)
    @user2   = users(:SYUNIN)
    @project = projects(:X)
    @work    = @user.works.build( project_id: @project.id,
                                  content:    "加減速制御モデルの開発",
                                  start_time: Time.zone.parse('2021-11-23 15:15:12'),
                                  end_time:   Time.zone.parse('2021-11-23 15:45:34') )
  end

  test "should be valid" do
    assert @work.valid?
  end

  test "user_id should be present" do
    @work.user_id = " ";
    assert_not @work.valid?
  end

  test "project_id should be present" do
    @work.project_id = " "
    assert_not @work.valid?
  end

  test "content should be present" do
    @work.content = " "
    assert_not @work.valid?
  end

  test "content should not be too long" do
    @work.content = "a" * 31
    assert_not @work.valid?
  end

  test "start_time should be present" do
    @work.start_time = nil
    assert_not @work.valid?
  end

  test "end_time should be present" do
    @work.end_time = nil
    assert_not @work.valid?
  end

  test "start_time should be minutes integrity" do
    @work.start_time = Time.zone.parse('2021-11-23 15:31:00')
    assert_not @work.valid?
  end

  test "end_time shoud be minutes integrity" do
    @work.end_time = Time.zone.parse('2021-11-23 16:05:00')
    assert_not @work.valid?
  end

  test "start_time should be earlier than end_time " do
    @work.start_time = Time.zone.parse('2021-11-23 16:45:34')
    assert_not @work.valid?
  end

  test "work period validation" do
    duplicate_work = @work.dup
    assert @work.save
    duplicate_work.start_time = Time.zone.parse('2021-11-23 15:30:12')
    assert_not duplicate_work.valid?
    duplicate_work.start_time = Time.zone.parse('2021-11-23 15:45:34')
    duplicate_work.end_time   = Time.zone.parse('2021-11-23 16:45:34')
    assert duplicate_work.valid?
    duplicate_work.start_time = Time.zone.parse('2021-11-23 15:30:12')
    assert_not duplicate_work.valid?
    duplicate_work.user_id   = @user2.id
    duplicate_work.user_name = @user2.name
    assert duplicate_work.valid?
  end

end
