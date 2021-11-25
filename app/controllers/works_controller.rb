class WorksController < ApplicationController
  include WorksHelper
  include SessionsHelper

  before_action :logged_in_user
  before_action :admin_user, only: [:show, :search]
  before_action :correct_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_pull_down_list_for_time_input
  before_action :set_instance_variables_by_user_id_and_day, only: [:new, :create, :show]
  before_action :set_instance_variables_by_work_id, only: [:edit, :update, :destroy]
  before_action :set_pull_down_list_for_works_search, only: [:search]

  def show
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(works_params)
    if @work.save
      flash[:success] = "工数を登録しました。"
      redirect_to "/works/#{@user_id}/#{@date}/new"
    else
      @s_hour = params[:work][:start_hours] if params[:work][:start_hours].present?
      @s_min  = params[:work][:start_minutes] if params[:work][:start_minutes].present?
      @e_hour = params[:work][:end_hours] if params[:work][:end_hours].present?
      @e_min  = params[:work][:end_minutes] if params[:work][:end_minutes].present?
      render 'works/new'
    end
  end

  def edit
  end

  def update
    if @work.update_attributes(works_params)
      flash[:success] = "登録内容を変更しました"
      redirect_to "/works/#{@user_id}/#{@date}/new"
    else
      render 'works/edit'
    end
  end

  def destroy
    @work.destroy
    flash[:success] = "工数を削除しました。"
    redirect_to "/works/#{@user_id}/#{@date}/new"
  end

  def search
    @search_params = works_search_params
    @works = Work.search(@search_params) unless works_search_params_is_empty?
    if params[:search].present? && params[:search][:searching] && @works.blank?
      flash.now[:danger] = "条件に該当する工数が存在しません。"
    end
    @sum_works_time = sum_works_time
  end

  private

    def user_name
      User.find_by(id: params[:work][:user_id]).name unless params[:work][:user_id].blank?
    end

    def project_name
      Project.find_by(id: params[:work][:project_id]).name unless params[:work][:project_id].blank?
    end

    def project_code
      Project.find_by(id: params[:work][:project_id]).code unless params[:work][:project_id].blank?
    end

    def date_time(date, hours, minutes)
      Time.zone.parse(date+" "+hours+":"+minutes+":00") unless date.empty? || hours.empty? || minutes.empty?
    end

    def works_params
      params[:work][:user_name]    = user_name
      params[:work][:project_name] = project_name
      params[:work][:project_code] = project_code
      params[:work][:start_time]   = date_time(@date.to_s, params[:work][:start_hours], params[:work][:start_minutes])
      params[:work][:end_time]     = date_time(@date.to_s, params[:work][:end_hours],   params[:work][:end_minutes])
      params.require(:work).permit(:user_id, :user_name, :project_id, :project_name, :project_code, :content, :start_time, :end_time)
    end

    def works_search_params
      params.fetch(:search, {}).permit( :year,
                                        :month,
                                        :user_name,
                                        :user_name_pull_down,
                                        :project_name_pull_down,
                                        :project_name )
    end

    def works_search_params_is_empty?
      return true if @search_params.blank?
      if (@search_params[:year].blank?         || @search_params[:month].blank?) &&
         @search_params[:user_name].blank?     && @search_params[:user_name_pull_down].blank? &&
         @search_params[:project_name].blank?  && @search_params[:project_name_pull_down].blank?

        return true
      else
        return false
      end
    end

    def sum_works_time
      return if @works.blank?
      sum_seconds = 0
      @works.each do |work|
        sum_seconds += work.end_time.to_i - work.start_time.to_i
      end
      return seconds_to_hours_and_minutes(sum_seconds)
    end

    #before_action

    def set_pull_down_list_for_time_input
      @hours = []
      (0..23).each do |h|
        @hours.push([h.to_s, h.to_s])
      end
      @minutes = []
      0.step(45, 15) do |m|
        @minutes.push([m.to_s, m.to_s])
      end
    end

    def set_pull_down_list_for_works_search
      @user_names = []
      users = User.all
      users.each do |user|
        @user_names.push([user.name, user.name])
      end

      @project_names = []
      projects = Project.all
      projects.each do |project|
        @project_names.push([project.name, project.name])
      end

      @years = []
      year = Time.zone.now.year
      (-3..0).each do |diff|
        y = year + diff
        @years.push([y.to_s, y.to_s])
      end

      @months = []
      (1..12).each do |m|
        @months.push([m.to_s, m.to_s])
      end
    end

    def set_instance_variables_by_user_id_and_day
      date_wtz = Time.zone.parse(params[:date])
      range = date_wtz.beginning_of_day..date_wtz.end_of_day
      @works   = Work.where(user_id: params[:user_id] ,start_time: range)
      @user_id = params[:user_id]
      @date    = date_wtz.to_date
    end

    def set_instance_variables_by_work_id
      @work = Work.find_by(id: params[:id])
      @user_id = @work.user_id
      @date = @work.start_time.to_date
      range = @date.beginning_of_day..@date.end_of_day
      @works = Work.where(user_id: @user_id, start_time: range)
      @while_editing = @work.id
      @s_hour = @work.start_time.hour
      @s_min  = @work.start_time.min
      @e_hour = @work.end_time.hour
      @e_min  = @work.end_time.min
    end

    def correct_user
      redirect_to root_url if params[:user_id].blank? && params[:id].blank?
      unless params[:user_id].blank?
        @user_id = params[:user_id]
      else
        work = Work.find_by(id: params[:id])
        if work.blank?
          redirect_to root_url
          return
        else
          @user_id = work.user_id
        end
      end
      user = User.find_by(id: @user_id)
      redirect_to root_url unless current_user?(user)
    end

end
