class WorksController < ApplicationController
  before_action :get_works, only: [:new, :show, :create]

  def new
    @work    = Work.new
    @user_id = params[:user_id]
    set_pull_down_list_for_time_input
  end

  def show
  end

  def create
    @work = Work.new(works_params)
    if @work.save
      flash[:success] = "工数を登録しました。"
      redirect_to "/works/#{params[:user_id]}/#{params[:day]}/new"
    else
      @user_id = params[:user_id]
      @date = Time.zone.parse(params[:day]).to_date
      set_pull_down_list_for_time_input
      render 'works/new'
    end
  end

  def edit
    @work = Work.find_by(id: params[:id])
    @date = @work.start_time.to_date
    range = @date.beginning_of_day..@date.end_of_day
    @works = Work.where(user_id: @work.user_id, start_time: range)
    @while_editing = @work.id
    set_pull_down_list_for_time_input
  end

  def destroy
    work    = Work.find_by(id: params[:id])
    day     = work.start_time.to_date
    user_id = work.user_id
    work.destroy
    flash[:success] = "工数を削除しました。"
    redirect_to "/works/#{user_id}/#{day}/new"
  end

  private

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

    #before_action
    def get_works
      date_wtz = Time.zone.parse(params[:day])
      range = date_wtz.beginning_of_day..date_wtz.end_of_day
      @works = Work.where(user_id: params[:user_id] ,start_time: range)
      @date = date_wtz.to_date
    end

    def user_name
      User.find_by(id: params[:work][:user_id]).name unless params[:work][:user_id].blank?
    end

    def project_name
      Project.find_by(id: params[:work][:project_id]).name unless params[:work][:project_id].blank?
    end

    def project_code
      Project.find_by(id: params[:work][:project_id]).code unless params[:work][:project_id].blank?
    end

    def date_time(day, hours, minutes)
      Time.zone.parse(day+" "+hours+":"+minutes+":00") unless day.empty? || hours.empty? || minutes.empty?
    end

    def works_params
      params[:work][:user_name]    = user_name
      params[:work][:project_name] = project_name
      params[:work][:project_code] = project_name
      params[:work][:start_time]   = date_time(params[:day], params[:work][:start_hours], params[:work][:start_minutes])
      params[:work][:end_time]     = date_time(params[:day], params[:work][:end_hours], params[:work][:end_minutes])
      params.require(:work).permit(:user_id, :user_name, :project_id, :project_name, :project_code, :content, :start_time, :end_time)
    end

end
