module ApplicationHelper
  def day_of_week(day)
    day_week = ""
    day_week = Date::DAYNAMES[Date.parse(day).wday] if day.is_a? String
    day_week = Date::DAYNAMES[day.wday] if day.is_a? Date
    day_week = Date::DAYNAMES[day % 7] if day.is_a? Integer
    day_week
  end

  def formatted_date(day)
    "#{day_of_week(day)}, #{day.strftime("%b %d, %Y")}"
  end

  def rating_as_stars(rating)
    stars = (0..5).map do |x|
      if x < rating.floor
        icon('fas', 'star', class: 'strong')
      elsif (rating - x).positive? && (rating - x) < 1
        icon('fas', 'star-half-alt', class: 'strong')
      elsif rating.ceil < x
        icon('far', 'star', class: 'strong')
      end
    end

    Nokogiri::HTML.parse(stars.join).to_html.html_safe
  end

  def handle_missing_mapbox_gl_css
    # if request.path is cars#index or cars#show path, then load the map.scss
    mapbox_require_pattern = %r{/cars(/?[0-9]*)?}
    puts "mapbox should be displayed, #{request.path.match(mapbox_require_pattern)}"
    return unless request.path.match(mapbox_require_pattern)

    stylesheet_link_tag 'map', media: 'all', 'data-turbolinks-track': 'reload'
  end
end
