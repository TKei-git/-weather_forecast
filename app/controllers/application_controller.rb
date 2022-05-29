class ApplicationController < ActionController::Base
    require 'uri'
    require 'net/http'

    def sample
        uri = URI('https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json')
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

        resdetail = resbody[0]["timeSeries"]
        resweek = resbody[1]["timeSeries"]

        resultDetail = JmaDetail.Create_jma_detail(resdetail, "130010", "44132")
        resultWeek = JmaWeek.Create_jma_week(resweek, "130010", "44132")

        resultDetail = JmaDetail.where(date: Date.current..)
        resultWeek = JmaWeek.where(date: Date.current..)

        render html: [resultDetail,resultWeek]
=begin

=end
    end
    
end
