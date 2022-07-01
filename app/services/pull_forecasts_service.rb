class PullForecastsService

    def initialize(code)
        @area_code = code
    end

    def pull_data
        recently = {}
        weekly   = {}

        [
            {
                service_name: "気象庁",
                data_obj: JapanMeteorologicalAgencyService.new(@area_code)
            },
            {
                service_name: "ウェザーニュース",
                data_obj: JapanMeteorologicalAgencyService.new(@area_code)
            }
        ].each do | obj |
            recently[obj[:service_name]] = obj[:data_obj].pull_recently()
            weekly[obj[:service_name]]   = obj[:data_obj].pull_weekly()
        end

        return {recently: recently, weekly: weekly}
        
    end

end