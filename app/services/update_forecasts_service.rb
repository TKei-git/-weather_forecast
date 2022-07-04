class UpdateForecastsService

    def initialize

    end

    def update_data
        results = {}
        [
            {
                service_name: "気象庁",
                data_obj: JapanMeteorologicalAgencyService.new
            },
            {
                service_name: "OpenWeatherMap",
                data_obj: OpenWeatherMapService.new
            },
            {
                service_name: "OpenMeteo",
                data_obj: OpenMeteoService.new
            }
        ].each do | obj |
            results[obj[:service_name]] = obj[:data_obj].update_daily_forecasts
        end

        return results
        
    end

end