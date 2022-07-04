# whenever 定期実行
# rake 'ファイル名':タスク名'
# Rails.root(Railsメソッド)を使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')

# .zshrcとrbenvのパスを指定するrakeを定義
job_type :rake, "source /Users/docha/.zshrc; export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

# cronを実行する環境変数(:development, :product, :test)
# 環境変数'RAILS_ENV'にセットされている変数またはdevelopmentを指定
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env
ENV.each { |k, v| env(k, v) } # これを追加

# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

# 一時間毎に実行
every 1.day, at: '5:30 am' do
  rake 'update_data_task:get_and_update_data', :environment => :development
end