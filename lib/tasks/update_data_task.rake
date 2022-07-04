namespace :update_data_task do
    desc 'Get forecasts and update tables'
    task :get_and_update_data => :environment do

        puts UpdateForecastsService.new.update_data

    end
end
