require 'test_helper'

class ProjectsSignupTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:SYATYO)
  end

  test "invalid signup information" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_no_difference 'Project.count' do
      post projects_signup_path, params: { project: { name: "", code: "" } }
    end
    assert_template 'projects/new'
  end

  test "valid signup information" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_difference 'Project.count', 1 do
      post projects_signup_path, params: { project: { name: "新規プロジェクト", code: "new" } }
    end
    follow_redirect!
    assert_template 'projects/index'
    assert_not flash.empty?
  end

  test "valid sign up information via valid csv" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_template 'projects/new'
    assert_match "<label for=\"file\">", response.body
    assert_match "<input accept=\".csv\" ", response.body
    #文字コードがshift jisの場合
    projects_csv = fixture_file_upload("/files/projects/valid_projects_sjis.csv", "text/csv")
    assert_difference 'Project.count', 1 do
      post import_projects_path, params: { file: projects_csv }
    end
    follow_redirect!
    assert_template 'projects/index'
    assert_not flash[:success].blank?
    assert flash[:danger].blank?
    assert_match "2190_1", response.body
    #文字コードがutf-8の場合(レコード2件)
    projects_csv = fixture_file_upload("/files/projects/valid_projects_utf8.csv", "text/csv")
    assert_difference 'Project.count', 2 do
      post import_projects_path, params: { file: projects_csv }
    end
    follow_redirect!
    assert_template 'projects/index'
    assert_not flash[:success].blank?
    assert flash[:danger].blank?
    assert_match "2100_1", response.body
    assert_match "2126_1", response.body
    #文字コードがBOM付きutf-8の場合
    projects_csv = fixture_file_upload("/files/projects/valid_projects_utf8_with_BOM.csv", "text/csv")
    assert_difference 'Project.count', 1 do
      post import_projects_path, params: { file: projects_csv }
    end
    follow_redirect!
    assert_template 'projects/index'
    assert_not flash[:success].blank?
    assert flash[:danger].blank?
    assert_match "2191_1", response.body
    assert_match "2190_1", response.body
    assert_match "2100_1", response.body
    assert_match "2126_1", response.body
  end

  test "invalid sign up information via invalid csv" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_template 'projects/new'
    #ヘッダーが無い場合
    projects_csv = fixture_file_upload("/files/projects/invalid_projects_no_header.csv", "text/csv")
    assert_no_difference 'Project.count' do
      post import_projects_path, params: { file: projects_csv }
    end
    follow_redirect!
    assert_not flash.empty?
    assert_template 'projects/new'
    #ヘッダーのみの場合
    projects_csv = fixture_file_upload("/files/projects/invalid_projects_only_header.csv", "text/csv")
    assert_no_difference 'Project.count' do
      post import_projects_path, params: { file: projects_csv }
    end
    follow_redirect!
    assert_not flash.empty?
    assert_template 'projects/new'
  end

  test "invalid sign up information via invalid extension file" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_template 'projects/new'
    projects_txt = fixture_file_upload("/files/projects/valid_projects_sjis.txt", "text/plain")
    assert_no_difference 'Project.count' do
      post import_projects_path, params: { file: projects_txt }
    end
    follow_redirect!
    assert_not flash.empty?
    assert_template 'projects/new'
  end

  test "invalid sign up information when not selected csv file" do
    log_in_as(@admin_user)
    get projects_signup_path
    assert_template 'projects/new'
    projects_csv = nil
    assert_no_difference 'Project.count' do
      post import_projects_path, params: { file: projects_csv }
    end
    follow_redirect!
    assert_not flash.empty?
    assert_template 'projects/new'
  end

end