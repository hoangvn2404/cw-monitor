class DailyPrice < ApplicationRecord
  belongs_to :warrant
  def calculate
    r = warrant.conversion
    c = current_warrant_price
    x = warrant.basic_stock_price
    s = current_stock_price
    return if s.blank?
    percent_need_to_increase = (r*c+x)/s-1
    percent_expired_profit = (s-x)/(r*c)-1
    self.update(percent_need_to_increase: percent_need_to_increase, percent_expired_profit: percent_expired_profit)
  end
end
