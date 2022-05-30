class JmaWeek < ApplicationRecord

    # Jsonを日ごとの天気情報配列に変換
    def self.shaping_data(weatherArrayObject, areaCode, areaTempCode, master)
        # 1週間の天気予報オブジェクトを抽出
        info = weatherArrayObject[1]["timeSeries"]

        areaWeather  = find_target_area(info[0], areaCode)
        areaTemp     = find_target_area(info[1], areaTempCode)

        # 日ごとの天気予報配列を作成
        forcastArray = create_forcast_array(info[0]["timeDefines"], areaWeather, areaTemp, areaCode, master)

        return forcastArray
    end

    # レコード作成or更新
    def self.create_or_update_records(array)
        result = []
        array.each do |hash|
            jma = JmaWeek.find_or_create_by(date: hash[:date], area_code: hash[:area_code])
            r = jma.update(
                weather:           hash[:weather],
                chance_of_rain:    hash[:chance_of_rain],
                reliability:       hash[:reliability],
                temperature_min:   hash[:temperature_min],
                temperature_max:   hash[:temperature_max]
            )
            result.push(r)
        end
        return result
    end

    private

    def self.find_target_area(object, code)
        return object["areas"].find {|n| n["area"]["code"] == code }
    end

    def self.create_forcast_array(times, weathers, temps, code, master)
        array = []
        times.each_with_index do |day, i|
            dt = Date.parse(day)
            array.push(
                {
                    date:            dt,
                    area_code:       code,
                    weather:         master.find_by(weather_code: weathers["weatherCodes"][i])["weather"],
                    chance_of_rain:  weathers["pops"][i],
                    reliability:     weathers["reliabilities"][i],
                    temperature_min: temps["tempsMin"][i],
                    temperature_max: temps["tempsMax"][i]
                }
            )
        end
        return array
    end
end
