require 'test_helper'

class HolidaysSignupTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:SYATYO)
  end

  test "invalid signup information" do
    log_in_as(@admin_user)
    get holidays_signup_path
    assert_no_difference 'Holiday.count' do
      post holidays_signup_path, params: { holiday: { name: "", date: "" } }
    end
    assert_select "div#error_explanation"
    assert_template 'holidays/new'
  end

  test "valid sign up information" do
    log_in_as(@admin_user)
    get holidays_signup_path
    assert_difference 'Holiday.count', 1 do
      post holidays_signup_path, params: { holiday: { name: "休日", date: Time.zone.parse('2021-12-31 00:00:00').to_date } }
    end
    follow_redirect!
    assert_template 'holidays/index'
    assert_not flash.empty?
  end

  test "valid sign up information via valid csv" do
    log_in_as(@admin_user)
    get holidays_path
    assert_template 'holidays/index'
    get holidays_path, params: { search: { year: "2020" } }
    assert_select "table", count: 0
    get holidays_signup_path
    assert_template 'holidays/new'
    #文字コードがshift jisの場合
    holidays_csv = fixture_file_upload("/files/holidays/valid_holidays_shift_jis.csv", "text/csv")
    post import_holidays_path, params: { file: holidays_csv }
    follow_redirect!
    assert_template 'holidays/index'
    assert_not flash.empty?
    get holidays_path, params: { search: { year: "2020" } }
    assert_select "table", count: 1
    assert_match "2020-01-01", response.body
    #文字コードがutf-8の場合
    holidays_csv = fixture_file_upload("/files/holidays/valid_holidays_utf8.csv", "text/csv")
    post import_holidays_path, params: { file: holidays_csv }
    follow_redirect!
    assert_template 'holidays/index'
    assert_not flash.empty?
    get holidays_path, params: { search: { year: "2020" } }
    assert_select "table", count: 1
    assert_match "2020-01-02", response.body
    #文字コードがBOM付きutf-8の場合
    holidays_csv = fixture_file_upload("/files/holidays/valid_holidays_utf8_with_BOM.csv", "text/csv")
    post import_holidays_path, params: { file: holidays_csv }
    follow_redirect!
    assert_template 'holidays/index'
    assert_not flash.empty?
    get holidays_path, params: { search: { year: "2020" } }
    assert_select "table", count: 1
    assert_match "2020-01-01", response.body
    assert_match "2020-01-02", response.body
    assert_match "2020-01-03", response.body
  end

  test "invalid sign up information via invalid csv" do
    log_in_as(@admin_user)
    get holidays_signup_path
    assert_template 'holidays/new'
    assert_match "<label for=\"file\">", response.body
    assert_match "<input accept=\".csv\" ", response.body
    #ヘッダーが無い場合
    holidays_csv = fixture_file_upload("/files/holidays/invalid_holidays_no_header.csv", "text/csv")
    post import_holidays_path, params: { file: holidays_csv }
    follow_redirect!
    assert_template 'holidays/new'
    assert_not flash.empty?
    get holidays_path, params: { search: { year: "2020" } }
    assert_select "table", count: 0
    #ヘッダーのみの場合
    holidays_csv = fixture_file_upload("/files/holidays/invalid_holidays_only_header.csv", "text/csv")
    post import_holidays_path, params: { file: holidays_csv }
    follow_redirect!
    assert_template 'holidays/new'
    assert_not flash.empty?
    get holidays_path, params: { search: { year: "2020" } }
    assert_select "table", count: 0
  end

  test "invalid sign up information via invalid extension file" do
    log_in_as(@admin_user)
    get holidays_signup_path
    assert_template 'holidays/new'
    holidays_txt = fixture_file_upload("/files/holidays/valid_holidays.txt", "text/plain")
    post import_holidays_path, params: { file: holidays_txt }
    follow_redirect!
    assert_not flash.empty?
    assert_template 'holidays/new'
  end

  test "invalid sign up information when not selected csv file" do
    log_in_as(@admin_user)
    get holidays_signup_path
    assert_template 'holidays/new'
    holidays_csv = nil
    post import_holidays_path, params: { file: holidays_csv }
    follow_redirect!
    assert_not flash.empty?
    assert_template 'holidays/new'
  end

end
