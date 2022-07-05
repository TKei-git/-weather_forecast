class ForecastsController < ApplicationController

    def index
        render json: PullForecastsService.new.pull_data
    end

    def update
        render json: UpdateForecastsService.new.update_data
        # redirect_to action: :show, area_code:@area_code
    end
end