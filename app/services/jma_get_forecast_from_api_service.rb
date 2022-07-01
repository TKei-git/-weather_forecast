class JmaGetForecastFromApiService
    
    require 'net/http'

    def initialize(code)
        @area_code = code
    end

    def call()
        uri = URI("https://www.jma.go.jp/bosai/forecast/data/forecast/#{@area_code}.json")
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
        return resbody
    end

end


