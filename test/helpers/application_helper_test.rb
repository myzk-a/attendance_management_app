require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "ASMobi:工数管理システム"
    assert_equal full_title("Help"), "Help | ASMobi:工数管理システム"
  end
end