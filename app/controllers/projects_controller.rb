class ProjectsController < ApplicationController
  include SessionsHelper

  before_action :logged_in_user
  before_action :admin_user

  def index
    @projects = Project.paginate(page: params[:page])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(name: params[:project][:name], code: params[:project][:code])
    if @project.save
      flash[:success] = "プロジェクトコードを登録しました。"
      redirect_to projects_url
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find_by(id: params[:id])
  end

  def update
    @project = Project.find_by(id: params[:id])
    if @project.update_attributes(project_params_update)
      flash[:success] = "プロジェクトコードを変更しました。"
      redirect_to projects_url
    else
      render 'edit'
    end
  end

  def destroy
    project = Project.find_by(id: params[:id])
    unless project.nil?
      project.destroy
      flash[:success] = "プロジェクトを削除しました。"
    end
    redirect_to projects_url
  end

  def import
    if params[:file].blank?
      flash[:danger] = "ファイルを選択してください。"
      redirect_to projects_signup_url
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = "拡張子が不正です。csvファイルを選択してください。"
      redirect_to projects_signup_url
    else
      result = Project.import(params[:file])
      if result == "all_saved"
        flash[:success] = "登録しました。"
        redirect_to projects_url
      elsif result == "some_are_invalid"
        flash[:danger] = "一部不正なデータがありました。正しいデータのみ登録しました。"
        redirect_to projects_url
      else
        flash[:danger] = "登録に失敗しました。データが不正です。"
        redirect_to projects_signup_url
      end
    end
  end

  private

    def project_params_update
      params.require(:project).permit(:code)
    end

end
