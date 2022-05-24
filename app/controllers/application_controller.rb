class ApplicationController < ActionController::Base
    require 'uri'
    require 'net/http'

    def sample
        dt = Date.current

        uri = URI('https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json')
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

        #今日と明日の天気予報をハッシュ化
        dayDefines = resbody[0]["timeSeries"][0]["timeDefines"]
        weathers = resbody[0]["timeSeries"][0]["areas"].find {|n| n["area"]["name"] == "東京地方" }["weathers"]
        rainTimeDefines = resbody[0]["timeSeries"][1]["timeDefines"]
        rainyPercent = resbody[0]["timeSeries"][1]["areas"].find {|n| n["area"]["name"] == "東京地方" }["pops"]
        tempTimeDefines = resbody[0]["timeSeries"][2]["timeDefines"]
        temps = resbody[0]["timeSeries"][2]["areas"].find {|n| n["area"]["name"] == "東京" }["temps"]

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
        
        #今日から1週間の天気予報を配列化
        weekWeathers = resbody[1]["timeSeries"][0]["areas"].find {|n| n["area"]["name"] == "東京地方" }["weatherCodes"]
        weekRainyPercent = resbody[1]["timeSeries"][0]["areas"].find {|n| n["area"]["name"] == "東京地方" }["pops"]
        weekMinTemps = resbody[1]["timeSeries"][1]["areas"].find {|n| n["area"]["name"] == "東京" }["tempsMin"]
        weekMaxTemps = resbody[1]["timeSeries"][1]["areas"].find {|n| n["area"]["name"] == "東京" }["tempsMax"]

        #DBから今日以降のレコード取得
        forecasts = JapanMeteorologicalAgency.where(district: "東京地方")

        jmaArray = []

        #週間ループ
        for num in 0..6 do

            #今日と明日
            if num < 2
                #レコードがあれば更新、なければ作成
                if forecasts.find {|n| n["date"] == (dt + num) } == nil
                    jma = JapanMeteorologicalAgency.new(
                        date: dt + num,
                        weather: weatherHash[(dt + num).strftime("%Y-%m-%d")],
                        temperature_min: tempHash[(dt + num).strftime("%Y-%m-%d") << "T00:00:00"],
                        temperature_max: tempHash[(dt + num).strftime("%Y-%m-%d") << "T09:00:00"],
                        chance_of_rain_06: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T00:00:00"],
                        chance_of_rain_12: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T06:00:00"],
                        chance_of_rain_18: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T12:00:00"],
                        chance_of_rain_24: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T18:00:00"],
                        district: "東京地方"
                    )
                    jmaArray.push(jma)
                else
                    forecasts.find {|n| n["date"] == dt }.update(
                        weather: weatherHash[(dt + num).strftime("%Y-%m-%d")],
                        temperature_min: tempHash[(dt + num).strftime("%Y-%m-%d") << "T00:00:00"],
                        temperature_max: tempHash[(dt + num).strftime("%Y-%m-%d") << "T09:00:00"],
                        chance_of_rain_06: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T00:00:00"],
                        chance_of_rain_12: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T06:00:00"],
                        chance_of_rain_18: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T12:00:00"],
                        chance_of_rain_24: rainyHash[(dt + num).strftime("%Y-%m-%d") << "T18:00:00"],
                    )
                end

            #明後日以降 
            else
                #レコードがあれば更新、なければ作成
                if forecasts.find {|n| n["date"] == (dt + num) } == nil
                    jma = JapanMeteorologicalAgency.new(
                        date: dt + num,
                        weather: weekWeathers[num],
                        temperature_min: weekMinTemps[num],
                        temperature_max: weekMaxTemps[num],
                        chance_of_rain: weekRainyPercent[num],
                        district: "東京地方"
                    )
                    jmaArray.push(jma)
                else
                    forecasts.find {|n| n["date"] == dt }.update(
                        weather: weekWeathers[num],
                        temperature_min: weekMinTemps[num],
                        temperature_max: weekMaxTemps[num],
                        chance_of_rain: weekRainyPercent[num],
                    )
                end
            end
        end

        render html: jmaArray
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
