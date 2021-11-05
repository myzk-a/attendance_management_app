class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      redirect_to current_user
    end
  end
  
end
