class ForecastsController < ApplicationController

    def index
        render json: PullForecastsService.new.pull_data
    end

    def show
        if ["jma", "owm", "om"].include?(params[:service])
            render json: PullForecastsService.new.pull_one_service_data(params[:service])
        else
            render json: "無効なサービス名です。"
        end
    end

    def update
        render json: UpdateForecastsService.new.update_data
        # redirect_to action: :show, area_code:@area_code
    end
end