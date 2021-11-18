class HolidaysController < ApplicationController
  include SessionsHelper

  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

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
      redirect_to holidays_url
    else
      render 'new'
    end
  end

  def edit
    @holiday = Holiday.find_by(id: params[:id])
  end

  def update
    @holiday = Holiday.find_by(id: params[:id])
    if @holiday.update_attributes(holiday_params)
      flash[:success] = "登録内容を変更しました。"
      redirect_to holidays_url
    else
      render 'edit'
    end
  end

  def destroy
    holiday = Holiday.find_by(id: params[:id])
    unless holiday.nil?
      holiday.destroy
      flash[:success] = "登録内容を削除しました。"
    end
    redirect_to holidays_url
  end

  private

    def holiday_params
      params.require(:holiday).permit(:name, :date)
    end

end
