# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

# every 5.minute do
#   command "cd /Users/hoangnguyen/Web/cw-monitor && heroku run rake cw:update_price"
# end

every '0,5,10,15,20,25,30,35,40,45,50,55 9-14 * * 1-5' do
  command "cd /Users/hoangnguyen/Web/cw-monitor && /opt/homebrew/bin/heroku run rake cw:update_price"
end