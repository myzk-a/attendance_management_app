class ProjectsController < ApplicationController
  include SessionsHelper

  before_action :admin_user, only: [:new, :create]

  def index
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

end
