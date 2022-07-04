class ForecastsController < ApplicationController

    def show
        @area_code = params[:area_code]
        render json: PullForecastsService.new(@area_code).pull_data
    end

    def update
        render json: UpdateForecastsService.new.update_data
        # redirect_to action: :show, area_code:@area_code
    end
end

=begin

def index
    #@jmaDetail = JmaDetail.where(date: Date.current..)
    #@jmaWeek = JmaWeek.where(date: Date.current..)
end
=end