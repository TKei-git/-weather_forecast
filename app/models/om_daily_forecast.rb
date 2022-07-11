class OmDailyForecast < ApplicationRecord

    validates :time, presence: true, uniqueness: true
end
