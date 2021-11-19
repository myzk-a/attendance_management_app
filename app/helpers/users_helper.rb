module UsersHelper
  def date_is_holiday?(date)
    holiday = Holiday.find_by(date: date)
    if date.saturday? || date.sunday? || holiday.present?
      if holiday.present?
        return holiday.name
      else
        return "weekend"
      end
    else
      return false
    end
  end
end
