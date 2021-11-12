class DaysController < ApplicationController
  before_action :get_works, only: [:show]

  def show
    
  end

  private

    def get_works
      date = DateTime.parse(params[:id])
      range = date.beginning_of_day..date.end_of_day
      @works = Work.where(start_time: range)
    end

end
