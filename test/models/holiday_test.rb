require 'test_helper'

class HolidayTest < ActiveSupport::TestCase
  def setup
    @holiday = holidays(:holiday)
  end

  test "should be valid" do
    assert @holiday.valid?
  end

  test "name should be present" do
    @holiday.name = " "
    assert_not @holiday.valid?
  end

  test "date should be preset" do
    @holiday.date = ""
    assert_not @holiday.valid?
  end

  test "name should not be too long" do
    @holiday.name = "a"*21
    assert_not @holiday.valid?
  end

  test "date should be unique" do
    duplicate_holiday = @holiday.dup
    @holiday.save
    duplicate_holiday.name = "test"
    assert_not duplicate_holiday.valid?
  end

end
