require 'test_helper'

class HolidaysEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:SYATYO)
    @holiday    = holidays(:holiday)
  end

  test "unsuccessful edit" do
    log_in_as(@admin_user)
    get edit_holiday_path(@holiday)
    assert_template 'holidays/edit'
    name = " "
    date = ""
    patch holiday_path(@holiday), params: { holiday: { name: name, date: date } }
    @holiday.reload
    assert_not_equal name, @holiday.name
    assert_not_equal date, @holiday.date
    assert_template 'holidays/edit'
  end

  test "successful edit" do
    log_in_as(@admin_user)
    get edit_holiday_path(@holiday)
    assert_template 'holidays/edit'
    name = "休日"
    date = DateTime.now.to_date
    patch holiday_path(@holiday), params: { holiday: { name: name, date: date } }
    assert_not flash.empty?
    assert_redirected_to holidays_path
    @holiday.reload
    assert_equal name, @holiday.name
    assert_equal date, @holiday.date
  end

end
