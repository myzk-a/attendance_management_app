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

  private

    def works_params
      user = User.find_by(id: params[:work][:user_id])
      params[:work][:user_name] = user.name
      params.require(:work).permit(:user_id, :user_name, :project_id, :project_name, :content, :start_time, :end_time)
    end

end
