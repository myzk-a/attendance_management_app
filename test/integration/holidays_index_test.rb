require 'test_helper'

class HolidaysIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user    = users(:SYATYO)
    @nonadmin_user = users(:BUTYO)
    @holiday       = holidays(:holiday)
  end
  
  test "index shoud include edit links and delete links when logged in admin user" do
    log_in_as(@admin_user)
    get holidays_path
    assert_template 'holidays/index'
    get holidays_path, params: { search: { year: "2021" } }
    assert_select "h2", "検索結果"
    assert_select "td", "2021-11-23"
    assert_select "a[href=?]", edit_holiday_path(@holiday), count: 1
    assert_select "a[href=?]", holiday_path(@holiday),      count: 1
    assert_difference 'Holiday.count', -1 do
      delete holiday_path(@holiday)
    end
  end

  test "index should not include edit links and delete links when logged in nonadmin user" do
    log_in_as(@nonadmin_user)
    get holidays_path
    assert_template 'holidays/index'
    get holidays_path, params: { search: { year: "2021" } }
    assert_select "h2", "検索結果"
    assert_select "td", "2021-11-23"
    assert_select "a[href=?]", edit_holiday_path(@holiday), count: 0
    assert_select "a[href=?]", holiday_path(@holiday),      count: 0
    assert_no_difference 'Holiday.count' do
      delete holiday_path(@holiday)
    end
  end

  test "index should nothing when target year has no holidays" do
    log_in_as(@admin_user)
    get holidays_path
    get holidays_path, params: { search: { year: "2020" } }
    assert_select "table", count: 0
  end

end
