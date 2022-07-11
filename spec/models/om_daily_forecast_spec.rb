require 'rails_helper'

RSpec.describe OmDailyForecast, type: :model do

    describe 'validates' do
        #let(:om) { OmDailyForecast.create(time: date) }
        #let(:om2) { OmDailyForecast.create(time: date) }
        let(:om) { FactoryBot.create(:om_daily_forecast, time: date) }
        let(:om2) { FactoryBot.create(:om_daily_forecast, time: date) }

        context 'time列が空ではない時' do
            let(:date) { Date.today }
            it "有効である" do
                expect(om).to be_valid
            end
        end
        context 'time列が空の時' do
            let(:date) { nil }
            it "無効である" do
                expect {om}.to raise_error("Validation failed: Time can't be blank")
                #expect(om).to be_invalid
            end
        end
        context 'time列が重複するとき' do
            let(:date) { Date.today }
            it "2件目は無効である" do
                expect(om).to be_valid
                expect {om2}.to raise_error("Validation failed: Time has already been taken")
            end
        end
    end
end