class ApplicationController < ActionController::Base
    require 'uri'
    require 'net/http'

    def sample
        uri = URI('https://weather.tsukumijima.net/api/forecast/city/400040')
        res = Net::HTTP.get_response(uri)
        hash = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

        hash["forecasts"].each do |h|
            wdate= h["date"],
            weather= h["detail"]["weather"],
            wind= h["detail"]["wind"],
            wave= h["detail"]["wave"],
            temperature_min= h["temperature"]["min"]["celsius"],
            temperature_max= h["temperature"]["max"]["celsius"],
            chance_of_rain_06= h["chanceOfRain"]["T00_06"],
            chance_of_rain_12= h["chanceOfRain"]["T06_12"],
            chance_of_rain_18= h["chanceOfRain"]["T12_18"],
            chance_of_rain_24= h["chanceOfRain"]["T18_24"],
            provider= "気象庁",
            area= hash["location"]["area"],
            prefecture= hash["location"]["prefecture"],
            district= hash["location"]["district"]
        end
        jma = JapanMeteorologicalAgency.new(
            weather: "台風",
            area: "南海"
        )
        #jma.save

        forecast = JapanMeteorologicalAgency.find_by(weather: "台風") 

        render html: forecast["area"]  


=begin

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
        




                    JapanMeteorologicalAgency.create(
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
=end
    end
end
