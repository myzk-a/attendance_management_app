class HolidaysController < ApplicationController
  include SessionsHelper

  before_action :admin_user, only: [:new, :create]

  def index
  end

  def new
    @holiday = Holiday.new
  end

  def create
  end

  def edit
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
