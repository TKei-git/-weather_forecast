class ApplicationController < ActionController::Base
    require 'uri'
    require 'net/http'

    def sample

        uri = URI('https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json')
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

        resdetail = resbody[0]["timeSeries"]
        resweek = resbody[1]["timeSeries"]

        #直近（2～3日分）の天気予報の各詳細配列を抽出
        dayDefines =      resdetail[0]["timeDefines"]
        targetArea =      resdetail[0]["areas"].find {|n| n["area"]["code"] == "130010" }
        weathers =        targetArea["weathers"]
        winds =           targetArea["winds"]
        waves =           targetArea["waves"]

        rainTimeDefines = resdetail[1]["timeDefines"]
        targetArea =      resdetail[1]["areas"].find {|n| n["area"]["code"] == "130010" }
        rainyPercent =    targetArea["pops"]

        tempTimeDefines = resdetail[2]["timeDefines"]
        targetArea =      resdetail[2]["areas"].find {|n| n["area"]["code"] == "44132" }
        temps =           targetArea["temps"]

        rainyHash = {}
        tempHash = {}
        
        rainTimeDefines.each_with_index do |time, i|
            rainyHash[time] = rainyPercent[i]
        end

        tempTimeDefines.each_with_index do |time, i|
            tempHash[time] = temps[i]
        end

        dayDefines.each_with_index do |day, i|
            dt = Date.parse(day)
            jma = JmaDetail.new(
                date:              dt,
                area_code:         "130010",
                weather:           weathers[i],
                wind:              winds[i],
                wave:              waves[i],
                chance_of_rain_06: rainyHash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                chance_of_rain_12: rainyHash[(dt).strftime("%Y-%m-%d") << "T06:00:00+09:00"],
                chance_of_rain_18: rainyHash[(dt).strftime("%Y-%m-%d") << "T12:00:00+09:00"],
                chance_of_rain_24: rainyHash[(dt).strftime("%Y-%m-%d") << "T18:00:00+09:00"],
                temperature_min:   tempHash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                temperature_max:   tempHash[(dt).strftime("%Y-%m-%d") << "T09:00:00+09:00"]
            )

        end

        jmaArray = []

        #今日から1週間の天気予報を配列化
        dayDefines =    resweek[0]["timeDefines"]
        targetArea =    resweek[0]["areas"].find {|n| n["area"]["code"] == "130010" }
        weathers =      targetArea["weatherCodes"]
        rainyPercent =  targetArea["pops"]
        reliabilities = targetArea["reliabilities"]

        targetArea =    resweek[1]["areas"].find {|n| n["area"]["code"] == "44132" }
        minTemps =      targetArea["tempsMin"]
        maxTemps =      targetArea["tempsMax"]

        dayDefines.each_with_index do |day, i|
            dt = Date.parse(day)
            jma = JmaWeek.new(
                date:            dt,
                area_code:       "130010",
                weather:         weathers[i],
                chance_of_rain:  rainyPercent[i],
                reliability:   reliabilities[i],
                temperature_min: minTemps[i],
                temperature_max: maxTemps[i]
            )
            jmaArray.push(jma)
        end

        render html: jmaArray
    end

=begin
        


        #DBから今日以降のレコード取得
        forecasts = JapanMeteorologicalAgency.where(district: "東京地方", date: dt)

        
    
        #週間ループ
        for num in 0..6 do

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



=end
    
end
