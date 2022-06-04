namespace :weathers do
    require 'net/http'
    desc 'Get weather forecast'
    task :get_data => :environment do
        # 気象庁から東京の天気情報取得API実行
        uri = URI('https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json')
        res = Net::HTTP.get_response(uri)
        resbody = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
        
        # 天気コードマスタを取得
        weatherCodeMaster = JmaWeatherCode.all

        # 天気予報のデータを整形
        detailData = JmaDetail.shaping_data(resbody, "130010", "44132")
        weekData = JmaWeek.shaping_data(resbody, "130010", "44132", weatherCodeMaster)

        begin
            ApplicationRecord.transaction do
                resultDetail = JmaDetail.create_or_update_records(detailData)
                resultWeek = JmaWeek.create_or_update_records(weekData)
            end
        rescue ActiveRecord::RecordInvalid => e
            puts e
        end

        puts JmaDetail.where(date: Date.current..)
        puts JmaWeek.where(date: Date.current..)
    end
end
