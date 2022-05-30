class ApplicationController < ActionController::Base
    require 'uri'
    require 'net/http'

    def sample
        uri = URI('https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json')
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

        resweek = resbody[1]["timeSeries"]

        detailData = JmaDetail.shaping_data(resbody, "130010", "44132")
=begin
        resultDetail = JmaDetail.create_or_update_records(detailData)

        resultDetail = JmaDetail.where(date: Date.current..)
        resultWeek = JmaWeek.where(date: Date.current..)


=end
        render html: detailData

    end
    
end
