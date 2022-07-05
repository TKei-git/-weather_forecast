class JapanMeteorologicalAgencyService

    require 'net/http'

    def initialize
        @area_code = "130000"
        @city_code = "130010"
        @temp_code = "44132"
    end

    def pull_daily_forecasts
        forecasts = []
        records = JmaDailyForecast.where(date: Date.current..)
        records.each do |record|
            obj = DailyForecastDto.new(
                record[:date],
                "気象庁",
                record[:weather],     
                record[:temperature_max],
                record[:temperature_min],
                nil,
                nil,
                nil,
                record[:chance_of_rain],
                nil,
                nil,
                nil,
                nil,
                nil,
                nil,
                nil,
                nil
            )
            forecasts.push(obj)
        end
        return merge_daily_detailed_forecasts(forecasts)
    end

    def update_daily_forecasts
        body = get_forecasts("https://www.jma.go.jp/bosai/forecast/data/forecast/#{@area_code}.json")
        
        daily_forecasts = update_records(body)
        daily_detailed_forecasts = update_detailed_records(body)
        return [daily_forecasts, daily_detailed_forecasts]
    end

    private
    
    def get_forecasts(uri)
        response = Net::HTTP.get_response(URI(uri))
        body = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    def update_records(body)
        times                 = body[1]["timeSeries"][0]["timeDefines"]
        object_of_weather     = body[1]["timeSeries"][0]["areas"].find {|n| n["area"]["code"] == @city_code }
        object_of_temperature = body[1]["timeSeries"][1]["areas"].find {|n| n["area"]["code"] == @temp_code }

        weather_code_master = JmaWeatherCode.all

        results = []
        times.each_with_index do |time, i|
            record = JmaDailyForecast.find_or_create_by(date: Date.parse(time))
            r = record.update(
                {
                    weather_code:          object_of_weather["weatherCodes"][i],
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
            results.push(r)
        end
        return results
    end

    def update_detailed_records(body)
        times_of_weather     = body[0]["timeSeries"][0]["timeDefines"]
        times_of_rain        = body[0]["timeSeries"][1]["timeDefines"]
        times_of_temperature = body[0]["timeSeries"][2]["timeDefines"]
        object_of_weather    = body[0]["timeSeries"][0]["areas"].find {|n| n["area"]["code"] == @city_code }
        array_of_rain        = body[0]["timeSeries"][1]["areas"].find {|n| n["area"]["code"] == @city_code }["pops"]
        array_of_temperature = body[0]["timeSeries"][2]["areas"].find {|n| n["area"]["code"] == @temp_code }["temps"]

        # 6時間ごとの降水確率のハッシュ作成（キーは時間）
        rain_hash           = make_hash(times_of_rain, array_of_rain)
        # 最高/最低気温のハッシュ作成（キーは時間、T00:00が最低、T09:00が最高）
        temperature_hash    = make_hash(times_of_temperature, array_of_temperature)
        weather_code_master = JmaWeatherCode.all

        results = []
        times_of_weather.each_with_index do |time, i|
            dt = Date.parse(time)
            record = JmaDailyDetailedForecast.find_or_create_by(date: dt)
            r = record.update(
                {
                    weather_code:      object_of_weather["weatherCodes"][i],
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
            results.push(r)
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

    def merge_daily_detailed_forecasts(forecasts)
        records = JmaDailyDetailedForecast.where(date: Date.current..)
        records.each do |record|
            obj = forecasts.find {|n| n.date == record[:date] }.forecast
            obj[:wind]            = record[:wind]
            obj[:wave]            = record[:wave]
            obj[:temperature_max] = record[:temperature_max] if obj[:temperature_max].nil?
            obj[:temperature_min] = record[:temperature_min] if obj[:temperature_min].nil?
            if obj[:chance_of_rain].nil?
                pop06 = record[:chance_of_rain_06].nil? ? "-" : record[:chance_of_rain_06].to_s
                pop12 = record[:chance_of_rain_12].nil? ? "-" : record[:chance_of_rain_12].to_s
                pop18 = record[:chance_of_rain_18].nil? ? "-" : record[:chance_of_rain_18].to_s
                pop24 = record[:chance_of_rain_24].nil? ? "-" : record[:chance_of_rain_24].to_s
                obj[:chance_of_rain]  = pop06 + "/" + pop12 + "/" + pop18 + "/" + pop24
            end
        end
        return forecasts
    end
end


