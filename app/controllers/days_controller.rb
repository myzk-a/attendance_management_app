class DaysController < ApplicationController
  before_action :get_works, only: [:new, :show]

  def new
  end

  def show
  end

  private

    def get_works
      date = DateTime.parse(params[:day])
      range = date.beginning_of_day..date.end_of_day
      @works = Work.where(user_id:params[:user_id] ,start_time: range)
    end

end
