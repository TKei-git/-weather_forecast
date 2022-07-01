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

    def update
        body = get_forecasts("https://www.jma.go.jp/bosai/forecast/data/forecast/#{@area_code}.json")

        recently = convert_recently(body[0])
        #weekly   = convert_weekly(body[1]["timeSeries"])
    end

    private
    
    def get_forecasts(uri)
        response = Net::HTTP.get_response(URI(uri))
        body = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    def convert_recently(body)
        weather_timeDefines = body["timeSeries"][0]["timeDefines"]
        rain_timeDefines = body["timeSeries"][1]["timeDefines"]
        temp_timeDefines = body["timeSeries"][2]["timeDefines"]
        weather = body["timeSeries"][0]["areas"].find {|n| n["area"]["code"] == "130010" }
        rain = body["timeSeries"][1]["areas"].find {|n| n["area"]["code"] == "130010" }["pops"]
        temp = body["timeSeries"][2]["areas"].find {|n| n["area"]["code"] == "44132" }["temps"]

        rainhash = {}
        rain_timeDefines.each_with_index do |time, i|
            rainhash[time] = rain[i]
        end

        temphash = {}
        temp_timeDefines.each_with_index do |time, i|
            temphash[time] = temp[i]
        end

        results = []
        weather_timeDefines.each_with_index do |time, i|
            dt = Date.parse(time)
            results.push(
                {
                    date:              dt,
                    area_code:         "130010",
                    weather:           weather["weathers"][i],
                    wind:              weather["winds"][i],
                    wave:              weather["waves"][i],
                    chance_of_rain_06: rainhash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                    chance_of_rain_12: rainhash[(dt).strftime("%Y-%m-%d") << "T06:00:00+09:00"],
                    chance_of_rain_18: rainhash[(dt).strftime("%Y-%m-%d") << "T12:00:00+09:00"],
                    chance_of_rain_24: rainhash[(dt).strftime("%Y-%m-%d") << "T18:00:00+09:00"],
                    temperature_min:   temphash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                    temperature_max:   temphash[(dt).strftime("%Y-%m-%d") << "T09:00:00+09:00"]
                }
            )
        end
        return results
    end

    def convert_weekly(body)

    end

end


