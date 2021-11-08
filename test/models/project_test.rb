require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  def setup
    @project = projects(:X)
  end
  
  test "should be valid?" do
    assert @project.valid?
  end
  
  test "name should be present" do
    @project.name = "  "
    assert_not @project.valid?
  end
  
  test "code should be present" do
    @project.code = "   "
    assert_not @project.valid?
  end
  
  test "name should be too long" do
    @project.name = "a" * 31
    assert_not @project.valid?
  end
  
  test "code should be too long" do
    @project.code = "a" * 31
    assert_not @project.valid?
  end
  
  test "name should be unique" do
    duplicate_project = @project.dup
    @project.save
    duplicate_project.code = "foo"
    assert_not duplicate_project.valid?
  end
  
  test "code should be unique" do
    duplicate_project = @project.dup
    @project.save
    duplicate_project.name = "foo"
    assert_not duplicate_project.valid?
  end
  
end
