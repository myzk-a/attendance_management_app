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
    redirect_to "/works/#{params[:user_id]}/#{params[:day]}/new"
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
      @hours   = [["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"], ["8", "8"], ["9", "9"], ["10", "10"], ["11", "11"], ["12", "12"]]
      @minutes = [["00", "00"], ["15", "15"], ["30", "30"], ["45", "45"]]
    end

    #before_action
    def get_works
      date_wtz = Time.zone.parse(params[:day])
      range = date_wtz.beginning_of_day..date_wtz.end_of_day
      @works = Work.where(user_id: params[:user_id] ,start_time: range)
      @date = date_wtz.to_date
    end

end
