require 'test_helper'

class HolidaysControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user    = users(:SYATYO)
    @nonadmin_user = users(:BUTYO)
    @holiday       = holidays(:holiday)
  end

  test "should get new when logged in admin user" do
    log_in_as(@admin_user)
    get holidays_signup_path
    assert_response :success
  end

  test "should get index when logged in admin user" do
    log_in_as(@admin_user)
    get holidays_path
    assert_response :success
  end

  test "should get edit when logged in admin user" do
    log_in_as(@admin_user)
    get edit_holiday_path(@holiday)
    assert_response :success
  end

  test "should delete holiday when logged in admin user" do
    log_in_as(@admin_user)
    assert_difference 'Holiday.count', -1 do
      delete holiday_path(@holiday)
    end
    assert_not flash.empty?
    assert_redirected_to holidays_path
  end

  test "should get index when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get holidays_path
    assert_response :success
  end

  test "should redirect new when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get holidays_signup_path
    assert_redirected_to root_url
  end

  test "should redirect new when not logged in" do
    get holidays_signup_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
    get holidays_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get edit_holiday_path(@holiday)
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get edit_holiday_path(@holiday)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    name = "休日"
    date = Date.today
    patch holiday_path(@holiday), params: { holiday: { name: name, date: date } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    name = "休日"
    date = Date.today
    patch holiday_path(@holiday), params: { holiday: { name: name, date: date } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    assert_no_difference 'Holiday.count' do
      delete holiday_path(@holiday)
    end
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in " do
    assert_no_difference 'Holiday.count' do
      delete holiday_path(@holiday)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect import when not logged in" do
    holidays_csv = fixture_file_upload("/files/holidays/valid_holidays_shift_jis.csv", "text/csv")
    assert_no_difference 'Holiday.count' do
      post import_holidays_path, params: { file: holidays_csv }
    end
    assert_redirected_to login_url
  end

  test "should redirect import when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    holidays_csv = fixture_file_upload("/files/holidays/valid_holidays_shift_jis.csv", "text/csv")
    assert_no_difference 'Holiday.count' do
      post import_holidays_path, params: { file: holidays_csv }
    end
    assert_redirected_to root_url
  end

end
