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
    load_csv(Project, projects_url, projects_signup_url, ["name", "code"])
  end

  private

    def project_params_update
      params.require(:project).permit(:code)
    end

end
