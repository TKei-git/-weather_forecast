class JmaDetail < ApplicationRecord

    # Jsonを日ごとの天気情報配列に変換
    def self.shaping_data(weatherArrayObject, areaCode, areaTempCode)
        # 直近（2～3日分）の天気予報オブジェクトを抽出
        info = weatherArrayObject[0]["timeSeries"]
        
        # 日ごとの天気情報のハッシュ作成（キーは時間）
        target      = find_target_area(info[0], areaCode)
        weatherHash = create_weather_hash(info[0]["timeDefines"], target["weathers"], target["winds"], target["waves"])

        # 6時間ごとの降水確率のハッシュ作成（キーは時間）
        target      = find_target_area(info[1], areaCode)
        rainyHash   = create_hash(info[1]["timeDefines"], target["pops"])

        # 最高/最低気温のハッシュ作成（キーは時間、T00:00が最低、T09:00が最高）
        target      = find_target_area(info[2], areaTempCode)
        tempHash    = create_hash(info[2]["timeDefines"], target["temps"])

        # 日ごとの天気予報配列を作成
        forcastArray = create_forcast_array(weatherHash, rainyHash, tempHash, areaCode)

        return forcastArray
    end

    # レコード作成or更新
    def self.create_or_update_records(array)
        result = []

        array.each do |hash|
            jma = JmaDetail.find_or_create_by(date: hash["date"], area_code: hash["areaCode"])
            r = jma.update(
                weather:           hash["weather"],
                wind:              hash["wind"],
                wave:              hash["wave"],
                chance_of_rain_06: hash["chance_of_rain_06"],
                chance_of_rain_12: hash["chance_of_rain_12"],
                chance_of_rain_18: hash["chance_of_rain_18"],
                chance_of_rain_24: hash["chance_of_rain_24"],
                temperature_min:   hash["temperature_min"],
                temperature_max:   hash["temperature_max"]
            )
            result.push(r)
        end

        return result
    end

    private

    def self.find_target_area(object, code)
        return object["areas"].find {|n| n["area"]["code"] == code }
    end

    def self.create_hash(times, values)
        hash = {}
        times.each_with_index do |time, i|
            hash[time] = values[i]
        end
        return hash
    end

    def self.create_weather_hash(times, weathers, winds, waves)
        hash = {}
        times.each_with_index do |time, i|
            hash[time] = {weather: weathers[i], wind: winds[i], wave: waves[i]}
        end
        return hash
    end

    def self.create_forcast_array(weatherHash, rainyHash, tempHash, code)
        array = []
        weatherHash.each {|key, value|
            dt = Date.parse(key)
            array.push(
                {
                    date:              dt,
                    area_code:         code,
                    weather:           value["weather"],
                    wind:              value["wind"],
                    wave:              value["wave"],
                    chance_of_rain_06: rainyHash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                    chance_of_rain_12: rainyHash[(dt).strftime("%Y-%m-%d") << "T06:00:00+09:00"],
                    chance_of_rain_18: rainyHash[(dt).strftime("%Y-%m-%d") << "T12:00:00+09:00"],
                    chance_of_rain_24: rainyHash[(dt).strftime("%Y-%m-%d") << "T18:00:00+09:00"],
                    temperature_min:   tempHash[(dt).strftime("%Y-%m-%d") << "T00:00:00+09:00"],
                    temperature_max:   tempHash[(dt).strftime("%Y-%m-%d") << "T09:00:00+09:00"]
                }
            )
        }
        return array
    end

end
