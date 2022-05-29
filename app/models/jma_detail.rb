class JmaDetail < ApplicationRecord

    def self.Create_jma_detail(weatherInfo, areaCode, areaTempCode)
        # 該当地域の直近（2～3日分）の天気予報を抽出
        dayDefines =      weatherInfo[0]["timeDefines"]
        targetArea =      weatherInfo[0]["areas"].find {|n| n["area"]["code"] == areaCode }
        weathers =        targetArea["weathers"]
        winds =           targetArea["winds"]
        waves =           targetArea["waves"]

        rainTimeDefines = weatherInfo[1]["timeDefines"]
        targetArea =      weatherInfo[1]["areas"].find {|n| n["area"]["code"] == areaCode }
        rainyPercent =    targetArea["pops"]

        tempTimeDefines = weatherInfo[2]["timeDefines"]
        targetArea =      weatherInfo[2]["areas"].find {|n| n["area"]["code"] == areaTempCode }
        temps =           targetArea["temps"]

        # 6時間ごとの降水確率のハッシュ作成（キーは時間）
        rainyHash = {}
        rainTimeDefines.each_with_index do |time, i|
            rainyHash[time] = rainyPercent[i]
        end

        # 最高/最低気温のハッシュ作成（キーは時間、T00:00が最低、T09:00が最高）
        tempHash = {}
        tempTimeDefines.each_with_index do |time, i|
            tempHash[time] = temps[i]
        end
        
        # 日ごとにインスタンス作成or更新
        result = []
        dayDefines.each_with_index do |day, i|
            dt = Date.parse(day)
            jma = JmaDetail.find_or_create_by(date: dt, area_code: areaCode)
            r = jma.update(
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
            result.push(r)
        end
        return result
    end
end
