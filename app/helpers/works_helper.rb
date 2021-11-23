module WorksHelper

  def seconds_to_hours_and_minutes(seconds)
    hours = seconds/3600
    seconds -= hours * 3600
    minutes = seconds/60
    return hours.to_s + "時間" + minutes.to_s + "分"
  end

end
