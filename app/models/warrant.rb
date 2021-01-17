class Warrant < ApplicationRecord
  default_scope { where('end_date >= ?', DateTime.now) }
  
  def calculate
    r = conversion
    c = current_warrent_price
    x = basic_stock_price
    s = current_stock_price
    percent_need_to_increase = (r*c+x)*10000/s-10000
    percent_expired_profile = (s-x)*10000/(r*c)-10000
    self.update(percent_need_to_increase: percent_need_to_increase, percent_expired_profile: percent_expired_profile)
  end

  def update_price
    require 'open-uri'
    html = open link
    doc = Nokogiri::HTML html  
    current_warrent_price = doc.css('#stockprice').text.gsub(",", "").gsub(" ", "")
    current_stock_price = doc.css('#basestock').text.gsub(",", "").gsub(" ", "")
    update(current_warrent_price: current_warrent_price, current_stock_price: current_stock_price)
    calculate
  end
end

