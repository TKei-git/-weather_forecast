class LocalWeatherForecastController < ApplicationController

    def index
        @jmaDetail = JmaDetail.where(date: Date.current..)
        @jmaWeek = JmaWeek.where(date: Date.current..)
    end

=begin
    require 'net/http'
        uri = URI('https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json')
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

        # 天気コードマスタを取得
        weatherCodeMaster = JmaWeatherCode.all

        # 天気予報のデータを整形
        detailData = JmaDetail.shaping_data(resbody, "130010", "44132")
        weekData = JmaWeek.shaping_data(resbody, "130010", "44132", weatherCodeMaster)

        # 天気予報データの最新化
        resultDetail = JmaDetail.create_or_update_records(detailData)
        resultWeek = JmaWeek.create_or_update_records(weekData)
=end
    
end
