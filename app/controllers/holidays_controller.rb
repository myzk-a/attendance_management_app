class HolidaysController < ApplicationController
  include SessionsHelper

  before_action :admin_user, only: [:new, :create, :edit]

  def index
    @holidays = Holiday.all
  end

  def new
    @holiday = Holiday.new
  end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      flash[:success] = "休日を登録しました。"
      redirect_to holidays_path
    else
      render 'new'
    end
  end

  def edit
    @holiday = Holiday.find_by(id: params[:id])
  end

  def update
  end

  def destroy
  end

  private

    def holiday_params
      params.require(:holiday).permit(:name, :date)
    end

end
