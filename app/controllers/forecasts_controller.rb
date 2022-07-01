class ForecastsController < ApplicationController

    def show
        @area_code = params[:area_code]
        render json: PullForecastsService.new(@area_code).pull_data
    end

    def update
        @area_code = params[:area_code]
        @area_temp_code = "44132"

        render json: UpdateForecastsService.new(@area_code).update_data
        # redirect_to action: :show, area_code:@area_code
    end
end

=begin

def index
    #@jmaDetail = JmaDetail.where(date: Date.current..)
    #@jmaWeek = JmaWeek.where(date: Date.current..)
end

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