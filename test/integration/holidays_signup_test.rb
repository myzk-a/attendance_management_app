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
    assert_template 'holidays/new'
  end

  test "valid sign up information" do
    log_in_as(@admin_user)
    get holidays_signup_path
    assert_difference 'Holiday.count', 1 do
      post holidays_signup_path, params: { holiday: { name: "休日", date: DateTime.now.to_date } }
    end
    follow_redirect!
    assert_template 'holidays/index'
    assert_not flash.empty?
  end

end
