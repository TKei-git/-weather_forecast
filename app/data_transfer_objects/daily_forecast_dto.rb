class DailyForecastDto
    attr_reader :date, :forecast

    def initialize(
            date,
            source,
            weather,     
            temperature_max,
            temperature_min,
            feeling_temperature_max,
            feeling_temperature_min,
            humidity,
            chance_of_rain,
            precipitation,
            snowfall,
            wind,
            wind_speed,
            wind_direction,
            wave,
            sunrise,
            sunset
        )
        @date     = date
        @forecast = {}
        @forecast[:source]                  = source
        @forecast[:weather]                 = weather     
        @forecast[:temperature_max]         = temperature_max
        @forecast[:temperature_min]         = temperature_min
        @forecast[:feeling_temperature_max] = feeling_temperature_max
        @forecast[:feeling_temperature_min] = feeling_temperature_min
        @forecast[:humidity]                = humidity
        @forecast[:chance_of_rain]          = chance_of_rain
        @forecast[:precipitation]           = precipitation
        @forecast[:snowfall]                = snowfall
        @forecast[:wind]                    = wind
        @forecast[:wind_speed]              = wind_speed
        @forecast[:wind_direction]          = wind_direction
        @forecast[:wave]                    = wave
        @forecast[:sunrise]                 = sunrise
        @forecast[:sunse]                   = sunset    
    end
end