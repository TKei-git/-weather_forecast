class WeeklyForecastDto
    
    def initialize(
            date,
            weather,     
            chance_of_rain,
            temperature_min,
            temperature_max
        )
        @date              = date
        @weather           = weather 
        @chance_of_rain = chance_of_rain
        @temperature_min   = temperature_min
        @temperature_max   = temperature_max
    end
end