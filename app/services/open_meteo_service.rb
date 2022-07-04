class OpenMeteoService
    require 'net/http'

    def initialize

    end

    def pull_daily_forecasts

    end

    def update_daily_forecasts
        body = get_forecasts("https://api.open-meteo.com/v1/forecast?latitude=35.6785&longitude=139.6823&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,precipitation_sum,rain_sum,showers_sum,snowfall_sum,precipitation_hours,windspeed_10m_max,windgusts_10m_max,winddirection_10m_dominant&current_weather=true&timeformat=unixtime&timezone=Asia%2FTokyo")
        result = update_records(body["daily"])
    end

    private

    def get_forecasts(uri)
        response = Net::HTTP.get_response(URI(uri))
        body = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    def update_records(obj)
        results = []
        (0..6).each do |i|
            record = OmDailyForecast.find_or_create_by(time: Time.at(obj["time"][i]).in_time_zone('Tokyo').to_date)
            r = record.update(
                sunrise:                    Time.at(obj["sunrise"][i]).in_time_zone('Tokyo').to_time,
                sunset:                     Time.at(obj["sunset"][i]).in_time_zone('Tokyo').to_time,
                weathercode:                obj["weathercode"][i],
                temperature_2m_max:         obj["temperature_2m_max"][i],
                temperature_2m_min:         obj["temperature_2m_min"][i],
                apparent_temperature_max:   obj["apparent_temperature_max"][i],
                apparent_temperature_min:   obj["apparent_temperature_min"][i],
                precipitation_sum:          obj["precipitation_sum"][i],
                rain_sum:                   obj["rain_sum"][i],
                showers_sum:                obj["showers_sum"][i],
                snowfall_sum:               obj["snowfall_sum"][i],
                precipitation_hours:        obj["precipitation_hours"][i],
                windspeed_10m_max:          obj["windspeed_10m_max"][i],
                windgusts_10m_max:          obj["windgusts_10m_max"][i],
                winddirection_10m_dominant: obj["winddirection_10m_dominant"][i]
            )
            results.push(r)
        end
        return results
    end
end