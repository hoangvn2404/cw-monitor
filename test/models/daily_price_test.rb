# == Schema Information
#
# Table name: daily_prices
#
#  id                       :bigint           not null, primary key
#  date                     :date
#  warrant_id               :integer
#  current_warrant_price    :integer
#  current_stock_price      :integer
#  volumn                   :integer
#  percent_need_to_increase :float
#  percent_expired_profit   :float
#  percent_premium          :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  yesterday_stock_price    :integer
#  yesterday_warrant_price  :integer
#  change_in_warrant        :float
#  change_in_stock          :float
#
require "test_helper"

class DailyPriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
