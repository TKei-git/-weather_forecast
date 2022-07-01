class UpdateForecastsService

    def initialize(code)
        @area_code = code
    end

    def update_data
        results = {}
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
            results[obj[:service_name]] = obj[:data_obj].update
        end

        return results
        
    end

end