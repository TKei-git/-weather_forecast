class RecentlyForecastDto
    
    def initialize(
            date,
            weather,     
            chance_of_rain_06,
            chance_of_rain_12,
            chance_of_rain_18,
            chance_of_rain_24,
            temperature_min,
            temperature_max
        )
        @date              = date
        @weather           = weather 
        @chance_of_rain_06 = chance_of_rain_06
        @chance_of_rain_12 = chance_of_rain_12
        @chance_of_rain_18 = chance_of_rain_18
        @chance_of_rain_24 = chance_of_rain_24
        @temperature_min   = temperature_min
        @temperature_max   = temperature_max
    end
end