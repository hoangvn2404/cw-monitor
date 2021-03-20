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
class DailyPrice < ApplicationRecord
  belongs_to :warrant
  def calculate
    r = warrant.conversion
    x = warrant.basic_stock_price
    w = current_warrant_price
    yw = yesterday_warrant_price
    s = current_stock_price
    ys = yesterday_stock_price
    return if s.blank?
    percent_need_to_increase = (r*w+x)/s-1
    percent_expired_profit = (s-x)/(r*w)-1
    change_in_stock = ys.present? ? (s-ys)/ys.to_f*100 : nil
    change_in_warrant = yw.present? ? (w-yw)/yw.to_f*100 : nil

    # binding.pry if self.warrant.code == "CSTB2007" && date == Date.parse("Fri, 26 Feb 2021")
    self.update(percent_need_to_increase: percent_need_to_increase, 
                percent_expired_profit: percent_expired_profit, 
                change_in_stock: change_in_stock, 
                change_in_warrant: change_in_warrant)
  end
end
