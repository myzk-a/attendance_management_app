class ProjectsController < ApplicationController
  include SessionsHelper

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
      redirect_to projects_path
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy
    project = Project.find_by(id: params[:id])
    unless project.nil?
      project.destroy
      flash[:success] = "プロジェクトを削除しました。"
    end
    redirect_to projects_url
  end

end
