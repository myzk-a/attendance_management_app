require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user    = users(:SYATYO)
    @nonadmin_user = users(:BUTYO)
  end

  test "admin user can get nonadmin user's page" do
    log_in_as(@admin_user)
    get user_path(@nonadmin_user)
    assert_response :success
    assert_select "div.simple-calendar"
    assert_select "h1", @nonadmin_user.name
  end

end