class JapanMeteorologicalAgencyService

    require 'net/http'

    def initialize(code)
        @area_code = code
    end

    def pull_recently
        forecasts = []

        records = JmaDetail.where(date: Date.current..)

        records.each do | record |
            recently_dto = RecentlyForecastDto.new(
                record[:date],
                record[:weather],
                record[:chance_of_rain_06],
                record[:chance_of_rain_12],
                record[:chance_of_rain_18],
                record[:chance_of_rain_24],
                record[:temperature_min],
                record[:temperature_max]
            )
            forecasts.push(recently_dto)
        end
        return forecasts
    end

    def pull_weekly
        forecasts = []

        records = JmaWeek.where(date: Date.current..)

        records.each do | record |
            weekly_dto = WeeklyForecastDto.new(
                record[:date],
                record[:weather],
                record[:chance_of_rain],
                record[:temperature_min],
                record[:temperature_max]
            )
            forecasts.push(weekly_dto)
        end
        return forecasts
    end

    def update_daily_forecasts
        body = get_forecasts("https://www.jma.go.jp/bosai/forecast/data/forecast/#{@area_code}.json")
        
        detailed_forecasts = convert_to_detailed_forecasts(body, "130010", "44132")
        weekly_forecasts   = convert_to_weekly_forecasts(body, "130010", "44132")

        return [detailed_forecasts, weekly_forecasts]
    end

    private
    
    def get_forecasts(uri)
        response = Net::HTTP.get_response(URI(uri))
        body = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    def convert_to_detailed_forecasts(body, city_code, temperature_code)
        times_of_weather     = body[0]["timeSeries"][0]["timeDefines"]
        times_of_rain        = body[0]["timeSeries"][1]["timeDefines"]
        times_of_temperature = body[0]["timeSeries"][2]["timeDefines"]
        object_of_weather    = body[0]["timeSeries"][0]["areas"].find {|n| n["area"]["code"] == city_code }
        array_of_rain        = body[0]["timeSeries"][1]["areas"].find {|n| n["area"]["code"] == city_code }["pops"]
        array_of_temperature = body[0]["timeSeries"][2]["areas"].find {|n| n["area"]["code"] == temperature_code }["temps"]

        rain_hash        = make_hash(times_of_rain, array_of_rain)
        temperature_hash = make_hash(times_of_temperature, array_of_temperature)

        weather_code_master = JmaWeatherCode.all

        results = []
        times_of_weather.each_with_index do |time, i|
            dt = Date.parse(time)
            results.push(
                {
                    date:              dt,
                    area_code:         city_code,
                    weather:           weather_code_master.find_by(weather_code: object_of_weather["weatherCodes"][i])["weather"],
                    detailed_weather:  object_of_weather["weathers"][i],
                    wind:              object_of_weather["winds"][i],
                    wave:              object_of_weather["waves"][i],
                    chance_of_rain_06: rain_hash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                    chance_of_rain_12: rain_hash[(dt).strftime("%Y-%m-%d") << "T06:00:00+09:00"],
                    chance_of_rain_18: rain_hash[(dt).strftime("%Y-%m-%d") << "T12:00:00+09:00"],
                    chance_of_rain_24: rain_hash[(dt).strftime("%Y-%m-%d") << "T18:00:00+09:00"],
                    temperature_min:   temperature_hash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                    temperature_max:   temperature_hash[(dt).strftime("%Y-%m-%d") << "T09:00:00+09:00"]
                }
            )
        end
        return results
    end

    def convert_to_weekly_forecasts(body, city_code, temperature_code)
        times_of_weather      = body[1]["timeSeries"][0]["timeDefines"]
        times_of_temperature  = body[1]["timeSeries"][1]["timeDefines"]
        object_of_weather     = body[1]["timeSeries"][0]["areas"].find {|n| n["area"]["code"] == city_code }
        object_of_temperature = body[1]["timeSeries"][1]["areas"].find {|n| n["area"]["code"] == temperature_code }

        weather_code_master = JmaWeatherCode.all

        results = []
        times_of_weather.each_with_index do |time, i|
            dt = Date.parse(time)
            results.push(
                {
                    date:                  dt,
                    area_code:             city_code,
                    weather:               weather_code_master.find_by(weather_code: object_of_weather["weatherCodes"][i])["weather"],
                    chance_of_rain:        object_of_weather["pops"][i],
                    reliability:           object_of_weather["reliabilities"][i],
                    temperature_min:       object_of_temperature["tempsMin"][i],
                    temperature_min_upper: object_of_temperature["tempsMinUpper"][i],
                    temperature_min_lower: object_of_temperature["tempsMinLower"][i],
                    temperature_max:       object_of_temperature["tempsMax"][i],
                    temperature_max_upper: object_of_temperature["tempsMaxUpper"][i],
                    temperature_max_lower: object_of_temperature["tempsMaxLower"][i]  
                }
            )
        end
        return results
    end

    def make_hash(times, values)
        hash = {}
        times.each_with_index do |time, i|
            hash[time] = values[i]
        end
        return hash
    end
end


