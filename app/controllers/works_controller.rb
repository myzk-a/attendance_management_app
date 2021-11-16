class WorksController < ApplicationController
  before_action :admin_user, only: :show
  before_action :correct_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_pull_down_list_for_time_input
  before_action :set_instance_variables_by_user_id_and_day, only: [:new, :create, :show]
  before_action :set_instance_variables_by_work_id, only: [:edit, :update, :destroy]

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
