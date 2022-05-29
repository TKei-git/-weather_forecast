class JmaWeek < ApplicationRecord

    def self.Create_jma_week(weatherInfo, areaCode, areaTempCode)

        # 該当地域の週間天気予報を抽出
        dayDefines =    weatherInfo[0]["timeDefines"]
        targetArea =    weatherInfo[0]["areas"].find {|n| n["area"]["code"] == areaCode }
        weathers =      targetArea["weatherCodes"]
        rainyPercent =  targetArea["pops"]
        reliabilities = targetArea["reliabilities"]

        targetArea =    weatherInfo[1]["areas"].find {|n| n["area"]["code"] == areaTempCode }
        minTemps =      targetArea["tempsMin"]
        maxTemps =      targetArea["tempsMax"]

        # 天気コードマスタを取得
        weatherCodeMaster = JmaWeatherCode.all

        # 日ごとにインスタンス作成or更新
        result = []
        dayDefines.each_with_index do |day, i|
            dt = Date.parse(day)
            jma = JmaWeek.find_or_create_by(date: dt, area_code: areaCode)
            r = jma.update(
                date:            dt,
                area_code:       areaCode,
                weather:         weatherCodeMaster.find_by(weather_code: weathers[i])["weather"],
                chance_of_rain:  rainyPercent[i],
                reliability:     reliabilities[i],
                temperature_min: minTemps[i],
                temperature_max: maxTemps[i]
            )
            result.push(r)
        end
        return result
    end
end
