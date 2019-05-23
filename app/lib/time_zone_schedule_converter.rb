module TimeZoneScheduleConverter
  class << self
    def convert(from_zone:, to_zone:, days:, hour:)
      if hour.blank? || to_zone == from_zone
        return {
          days: days,
          hour: hour
        }
      end

      adjusted_hour = ActiveSupport::TimeZone[from_zone]
        .parse("#{hour}:00:00")
        .in_time_zone(to_zone)
        .hour

      moved_forwards = moved_forwards? from_zone, to_zone

      adjusted_days = adjust_days(
        days,
        hour,
        adjusted_hour,
        moved_forwards
      )

      {
        days: adjusted_days,
        hour: adjusted_hour
      }
    end

    private

    def moved_forwards?(from_zone, to_zone)
      from_zone = ActiveSupport::TimeZone[from_zone]
      to_zone = ActiveSupport::TimeZone[to_zone]

      (from_zone.utc_offset - to_zone.utc_offset).negative?
    end

    def adjust_days(days, hour, adjusted_hour, moved_forwards)
      return days if days.size == Date::ABBR_DAYNAMES.size

      moved_to_previous_days = !moved_forwards && adjusted_hour > hour
      moved_to_next_days = moved_forwards && adjusted_hour < hour

      if moved_to_previous_days
        offset_days days, -1
      elsif moved_to_next_days
        offset_days days, 1
      else
        days
      end
    end

    def offset_days(days, offset)
      days.map do |d|
        new_ix = Date::ABBR_DAYNAMES.index(d) + offset
        new_ix = if new_ix >= Date::ABBR_DAYNAMES.size
                   0
                 elsif new_ix.negative?
                   Date::ABBR_DAYNAMES.size - 1
                 else
                   new_ix
                 end
        Date::ABBR_DAYNAMES[new_ix]
      end
    end
  end
end
