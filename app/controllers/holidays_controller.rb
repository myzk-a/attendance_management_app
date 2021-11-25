class HolidaysController < ApplicationController
  include SessionsHelper

  before_action :logged_in_user
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :import]
  before_action :set_pull_down_list, only: [:index]

  def index
    @search_params = search_params
    @holidays = Holiday.search(@search_params) unless search_params_is_empty?
  end

  def new
    @holiday = Holiday.new
  end

  def create
    @holiday = Holiday.new(holidays_params)
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
    if @holiday.update_attributes(holidays_params)
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

  def import
    load_csv(Holiday, holidays_url, holidays_signup_url)
  end


  private

    def holidays_params
      params.require(:holiday).permit(:name, :date)
    end

    def search_params
      params.fetch(:search, {}).permit(:year)
    end

    def search_params_is_empty?
      return true if @search_params.blank?
      @search_params[:year].blank? ? true : false
    end

    #beforeアクション
    def set_pull_down_list
      @years = []
      year = Time.zone.now.year
      (-3..0).each do |diff|
        y = year + diff
        @years.push([y.to_s+"年", y.to_s])
      end
    end

end
