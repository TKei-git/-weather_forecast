class ApplicationController < ActionController::Base
    require 'uri'
    require 'net/http'

    def sample
        uri = URI('https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json')
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

        dayDefines = resbody[0]["timeSeries"][0]["timeDefines"]
        weathers = resbody[0]["timeSeries"][0]["areas"].find {|n| n["area"]["name"] == "東京地方" }["weathers"]
        rainTimeDefines = resbody[0]["timeSeries"][1]["timeDefines"]
        rainyPercent = resbody[0]["timeSeries"][1]["areas"].find {|n| n["area"]["name"] == "東京地方" }["pops"]
        tempTimeDefines = resbody[0]["timeSeries"][2]["timeDefines"]
        temps = resbody[0]["timeSeries"][2]["areas"].find {|n| n["area"]["name"] == "東京" }["temps"]


        dt = Date.today

        weatherHash = {}
        rainyHash = {}
        tempHash = {}

        for num in 0..dayDefines.length-1 do
            weatherHash[dayDefines[num].slice(0..9)] = weathers[num]
        end

        for num in 0..rainTimeDefines.length-1 do
            rainyHash[rainTimeDefines[num].slice(0..18)] = rainyPercent[num]
        end

        for num in 0..tempTimeDefines.length-1 do
            tempHash[tempTimeDefines[num].slice(0..18)] = temps[num]
        end
        

        jma = JapanMeteorologicalAgency. new(
            date: dt,
            weather: weatherHash[dt.strftime("%Y-%m-%d")],
            temperature_min: tempHash[dt.strftime("%Y-%m-%d") << "T00:00:00"],
            temperature_max: tempHash[dt.strftime("%Y-%m-%d") << "T09:00:00"],
            chance_of_rain_06: rainyHash[dt.strftime("%Y-%m-%d") << "T00:00:00"],
            chance_of_rain_12: rainyHash[dt.strftime("%Y-%m-%d") << "T06:00:00"],
            chance_of_rain_18: rainyHash[dt.strftime("%Y-%m-%d") << "T12:00:00"],
            chance_of_rain_24: rainyHash[dt.strftime("%Y-%m-%d") << "T18:00:00"],
            district: "東京地方"
        )

        dbsave = JapanMeteorologicalAgency.where(date: jma["date"], district: jma["district"])
        #dbsave = jma.save

        forecast = JapanMeteorologicalAgency.where(date: jma["date"], district: jma["district"])

        render html: [dbsave]

    end

        


=begin
        jmaTomorrow = JapanMeteorologicalAgency.new(
            date: dt +1,
            weather: weatherHash[(dt+1).strftime("%Y-%m-%d")],
            temperature_min: tempHash[(dt+1).strftime("%Y-%m-%d") << "T00:00:00"],
            temperature_max: tempHash[(dt+1).strftime("%Y-%m-%d") << "T09:00:00"],
            chance_of_rain_06: rainyHash[(dt+1).strftime("%Y-%m-%d") << "T00:00:00"],
            chance_of_rain_12: rainyHash[(dt+1).strftime("%Y-%m-%d") << "T06:00:00"],
            chance_of_rain_18: rainyHash[(dt+1).strftime("%Y-%m-%d") << "T12:00:00"],
            chance_of_rain_24: rainyHash[(dt+1).strftime("%Y-%m-%d") << "T18:00:00"],
            district: "東京地方"
        )

        weekWeathers = resbody[1]["timeSeries"][0]["areas"].find {|n| n["area"]["name"] == "東京地方" }["weatherCodes"]
        weekRainyPercent = resbody[1]["timeSeries"][0]["areas"].find {|n| n["area"]["name"] == "東京地方" }["pops"]
        weekMinTemps = resbody[1]["timeSeries"][1]["areas"].find {|n| n["area"]["name"] == "東京" }["tempsMin"]
        weekMaxTemps = resbody[1]["timeSeries"][1]["areas"].find {|n| n["area"]["name"] == "東京" }["tempsMax"]

        for num in 2..6 do
            jmaaddday = JapanMeteorologicalAgency.new(
                date: dt + num,
                weather: weekWeathers[num],
                temperature_min: weekMinTemps[num],
                temperature_max: weekMaxTemps[num],
                #chance_of_rain: weekRainyPercent[num],
                district: "東京地方"
            )
        end


        .strftime("%Y-%m-%d")

        render html: [
            jmaToday["weather"],
            jmaToday["temperature_min"],
            jmaToday["temperature_max"],
            jmaToday["chance_of_rain_06"],
            jmaToday["chance_of_rain_12"],
            jmaToday["chance_of_rain_18"],
            jmaToday["chance_of_rain_24"],
            jmaToday["district"],
        ]

        hash["forecasts"].each do |h|
            jma = JapanMeteorologicalAgency.new(
                date: h["date"],
                weather: h["detail"]["weather"],
                wind: h["detail"]["wind"],
                wave: h["detail"]["wave"],
                temperature_min: h["temperature"]["min"]["celsius"],
                temperature_max: h["temperature"]["max"]["celsius"],
                chance_of_rain_06: h["chanceOfRain"]["T00_06"],
                chance_of_rain_12: h["chanceOfRain"]["T06_12"],
                chance_of_rain_18: h["chanceOfRain"]["T12_18"],
                chance_of_rain_24: h["chanceOfRain"]["T18_24"],
                provider: "気象庁",
                area: hash["location"]["area"],
                prefecture: hash["location"]["prefecture"],
                district: hash["location"]["district"]
            )

            forecast = JapanMeteorologicalAgency.where(date: jma["date"], district: jma["district"]) 

            if forecast.length == 0
                jma.save
            elsif forecast.length == 1
                forecast.update(
                    weather: jma["weather"],
                    wind: jma["wind"],
                    wave: jma["wave"],
                    temperature_min: jma["temperature_min"],
                    temperature_max: jma["temperature_max"],
                    chance_of_rain_06: jma["chance_of_rain_06"],
                    chance_of_rain_12: jma["chance_of_rain_12"],
                    chance_of_rain_18: jma["chance_of_rain_18"],
                    chance_of_rain_24: jma["chance_of_rain_24"],
                )
            end
        end


        [
            wdate,
            weather,
            wind,
            wave,
            temperature_min,
            temperature_max,
            chance_of_rain_06,
            chance_of_rain_12,
            chance_of_rain_18,
            chance_of_rain_24,
            provider,
            area,
            prefecture,
            district
        ]
        forecast = JapanMeteorologicalAgency.find_by(district: "筑後地方")
=end
    
end
