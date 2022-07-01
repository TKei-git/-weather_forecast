class TopController < ApplicationController
    def home
        @regions = [['東京', 130000], ['神奈川', 140000]]
    end
end
