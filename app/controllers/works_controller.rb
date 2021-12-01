class WorksController < ApplicationController
  include WorksHelper
  include SessionsHelper

  before_action :logged_in_user
  before_action :admin_user, only: [:show, :search]
  before_action :correct_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_date, only: [:new, :create, :show]
  before_action :set_pull_down_list_for_works_search, only: [:search]

  def show
    @user = User.find_by(id: params[:user_id])
    if @user.nil?
      redirect_to root_url
    else
      @date = params[:date].to_date
      range = Time.zone.parse(params[:date]).beginning_of_day..Time.zone.parse(params[:date]).end_of_day
      @works = @user.works.where(start_time: range)
    end
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @form = Form::WorkCollection.new
    @date = params[:date].to_date
    range = Time.zone.parse(params[:date]).beginning_of_day..Time.zone.parse(params[:date]).end_of_day
    @works = @user.works.where(start_time: range)
  end

  def create
    @user = User.find_by(id: params[:user_id])
    @form = Form::WorkCollection.new(works_collection_params)
    @date = params[:date].to_date
    range = Time.zone.parse(params[:date]).beginning_of_day..Time.zone.parse(params[:date]).end_of_day
    if @form.save
      flash[:success] = "登録しました。"
      @works = @user.works.where(start_time: range)
      redirect_to "/works/#{@user.id}/#{@date}/new"
    else
      @input_has_error = true
      @works = @user.works.where(start_time: range)
      render 'new'
    end
  end

  def edit
     @work = Work.find_by(id: params[:id])
     @user = @work.user
     @date = @work.start_time.to_date
     range = @date.beginning_of_day..@date.end_of_day
     @works = Work.where(user_id: @user.id, start_time: range)
     @while_editing = @work.id
  end

  def update
    @work = Work.find_by(id: params[:id])
    @user = @work.user
    @date = @work.start_time.to_date
    range = @date.beginning_of_day..@date.end_of_day
    @works = Work.where(user_id: @user.id, start_time: range)
    if @work.update_attributes(works_params)
      flash[:success] = "登録内容を変更しました"
      redirect_to "/works/#{@user.id}/#{@date}/new"
    else
      @while_editing = @work.id
      render 'works/edit'
    end
  end

  def destroy
    @work = Work.find_by(id: params[:id])
    @user = @work.user
    @date = @work.start_time.to_date
    range = @date.beginning_of_day..@date.end_of_day
    @works = Work.where(user_id: @user.id, start_time: range)
    @work.destroy
    flash[:success] = "工数を削除しました。"
    redirect_to "/works/#{@user.id}/#{@date}/new"
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

    def works_params
      params.require(:work).permit(:project_id, :content, :start_time, :end_time)
    end

    def works_collection_params
      params
      .require(:form_work_collection)
      .permit(works_attributes: [:signup, :user_id, :project_id, :content, :start_time, :end_time])
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

    def correct_user
      if params[:user_id].blank? && params[:id].blank?
        redirect_to root_url
        return
      end
      unless params[:user_id].blank?
        user = User.find_by(id: params[:user_id])
      else
        work = Work.find_by(id: params[:id])
        if work.blank?
          redirect_to root_url
          return
        else
          user = User.find_by(id: work.user_id)
        end
      end
      redirect_to root_url unless current_user?(user)
    end

    def correct_date
      date = Time.zone.parse(params[:date]).to_date
      today = Time.zone.now.to_date
      redirect_to root_url if date > today
    end

end
