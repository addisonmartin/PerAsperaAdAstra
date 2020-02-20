module ApplicationHelper
  # Enables pagination's frontend for all views.
  include Pagy::Frontend

  # Formats a date to a string in the format: Monday, January 2, 2006
  def format_date(date)
    if date.nil?
      date
    else
      date.strftime('%A, %B %-d, %Y')
    end
  end

end
