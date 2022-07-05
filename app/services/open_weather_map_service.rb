class OpenWeatherMapService
    require 'net/http'

    def initialize

    end

    def pull_daily_forecasts
        forecasts = []
        records = OwmDailyForecast.where(dt: Date.current..)
        records.each do |record|
            obj = DailyForecastDto.new(
                record[:dt],
                "OpenWeatherMap",
                record[:weather_description],     
                record[:temp_max],
                record[:temp_min],
                nil,
                nil,
                record[:humidity],
                record[:pop],
                record[:rain],
                nil,
                nil,
                record[:wind_speed],
                record[:wind_deg],
                nil,
                record[:sunrise],
                record[:sunset]
            )
            forecasts.push(obj)
        end
        return forecasts
    end

    def update_daily_forecasts
        body = get_forecasts("https://api.openweathermap.org/data/2.5/onecall?lat=35.6785&lon=139.6823&units=metric&appid=#{ENV["OWM_API_KEY"]}&lang=ja")
        result = update_records(body["daily"])
    end

    private

    def get_forecasts(uri)
        response = Net::HTTP.get_response(URI(uri))
        body = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    def update_records(array)
        results = []
        array.each do |obj|
            record = OwmDailyForecast.find_or_create_by(dt: Time.at(obj["dt"]).in_time_zone('Tokyo').to_date)
            r = record.update(
                sunrise:             Time.at(obj["sunrise"]).in_time_zone('Tokyo'),
                sunset:              Time.at(obj["sunset"]).in_time_zone('Tokyo'),
                moonrise:            Time.at(obj["moonrise"]).in_time_zone('Tokyo'),
                moonset:             Time.at(obj["moonset"]).in_time_zone('Tokyo'),
                moon_phase:          obj["moon_phase"],
                temp_day:            obj["temp"]["day"],
                temp_min:            obj["temp"]["min"],
                temp_max:            obj["temp"]["max"],
                temp_night:          obj["temp"]["night"],
                temp_eve:            obj["temp"]["eve"],
                temp_morn:           obj["temp"]["morn"],
                feels_like_day:      obj["feels_like"]["day"],
                feels_like_night:    obj["feels_like"]["night"],
                feels_like_eve:      obj["feels_like"]["eve"],
                feels_like_morn:     obj["feels_like"]["morn"],
                pressure:            obj["pressure"],
                humidity:            obj["humidity"],
                dew_point:           obj["dew_point"],
                wind_speed:          obj["wind_speed"],
                wind_deg:            obj["wind_deg"],
                wind_gust:           obj["wind_gust"],
                weather_id:          obj["weather"][0]["id"],
                weather_main:        obj["weather"][0]["main"],
                weather_description: obj["weather"][0]["description"],
                weather_icon:        obj["weather"][0]["icon"],
                clouds:              obj["clouds"],
                pop:                 obj["pop"],
                rain:                obj["rain"],
                uvi:                 obj["uvi"]
            )
            results.push(r)
        end
        return results
    end
end