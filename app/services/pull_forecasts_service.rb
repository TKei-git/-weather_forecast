class PullForecastsService

    def initialize

    end

    def pull_data
        forecasts = {}

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
            forecasts[obj[:service_name]] = obj[:data_obj].pull_daily_forecasts
        end
        return sort_forecasts(forecasts)
    end

    def pull_one_service_data(service)
        forecasts = {}
        case service
        when "jma" then
            obj = {
                service_name: "気象庁",
                data_obj: JapanMeteorologicalAgencyService.new
            }
        when "owm" then
            obj = {
                service_name: "OpenWeatherMap",
                data_obj: OpenWeatherMapService.new
            }
        when "om" then    
            obj = {
                service_name: "OpenMeteo",
                data_obj: OpenMeteoService.new
            }
        end
        forecasts[obj[:service_name]] = obj[:data_obj].pull_daily_forecasts
        return forecasts
    end

    private

    def sort_forecasts(forecasts)
        array = []
        Range.new(Date.current, Date.current + 6).each do |d|
            object = {
                date: d,
                forecasts: []
            }
            object[:forecasts].push(forecasts["気象庁"].find {|n| n.date == d }.nil? ? nil : forecasts["気象庁"].find {|n| n.date == d }.forecast)
            object[:forecasts].push(forecasts["OpenWeatherMap"].find {|n| n.date == d }.nil? ? nil : forecasts["OpenWeatherMap"].find {|n| n.date == d }.forecast)
            object[:forecasts].push(forecasts["OpenMeteo"].find {|n| n.date == d }.nil? ? nil : forecasts["OpenMeteo"].find {|n| n.date == d }.forecast)
            array.push(object)
        end
        return array
    end
end