class JapanMeteorologicalAgency < ApplicationRecord
    validates :date, presence: true
end
