class Setting < ApplicationRecord
  def self.parse_from_vndirect
    today = Date.today
    return if today.saturday? || today.sunday?
    yesterday = today.wday == 1 ? today - 3.days : today - 1.day
    require 'webdrivers'
    require 'watir'
    if chrome_bin = ENV["GOOGLE_CHROME_REAL"]
      Selenium::WebDriver::Chrome.path = chrome_bin
    end
    if chrome_driver = ENV["CHROME_DRIVER_REAL"]
      Selenium::WebDriver::Chrome::Service.driver_path = chrome_driver
    end

    link = "https://trade.vndirect.com.vn/chung-khoan/chung-quyen"
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto(link)
    browser.element(css: "#CMWG2104").wait_until(&:present?)
    content = browser.element(css: "#banggia-chungquyen-body")
    data = Nokogiri::HTML(content.inner_html)
    data.css('tr').each do |cw_data|
      code, issuer, end_date, tc, top, bottom, long3, long3_vol, long2, long2_vol, long1, long1_vol, current_warrant_price, volumn, variance, short1, short1_vol, short2, short2_vol, short3, short3_vol, max, min, total_volumn, stock, current_stock_price, ignore_1, ignore_2, basic_stock_price, conversion = cw_data.css('td').map(&:text)
      cw = Warrant.find_or_create_by(code: code)
      cw.stock = stock
      cw.issuer = issuer
      cw.link ||= "https://finance.vietstock.vn/chung-khoan-phai-sinh/#{code}/cw-tong-quan.htm"
      cw.end_date ||= Date.strptime(end_date, "%d/%m/%y")  
      cw.conversion = conversion.split(":")[0]
      cw.basic_stock_price = basic_stock_price.to_f * 1000
      cw.tham_chieu = tc.to_f*1000
      cw.current_warrant_price = current_warrant_price.present? ? current_warrant_price.to_f * 1000 : tc.to_f * 1000
      cw.current_stock_price = current_stock_price.to_f * 1000
      cw.save!
      today_price = cw.daily_prices.find_or_create_by(date: today)
      yesterday_price = cw.daily_prices.find_by_date(yesterday)    
      today_price.yesterday_stock_price = yesterday_price&.current_stock_price
      today_price.yesterday_warrant_price = yesterday_price&.current_warrant_price
      today_price.current_warrant_price = current_warrant_price.present? ? current_warrant_price.to_f * 1000 : tc.to_f * 1000
      today_price.current_stock_price = current_stock_price.to_f * 1000
      today_price.save
      today_price.calculate
    end  

    setting = Setting.first || Setting.create
    setting.update(last_run_date: Time.now)
  end

  def self.parse_from_ssi
    today = Date.today
    return if today.saturday? || today.sunday?
    yesterday = today.wday == 1 ? today - 3.days : today - 1.day
    require 'webdrivers'
    require 'watir'
    if chrome_bin = ENV["GOOGLE_CHROME_REAL"]
      Selenium::WebDriver::Chrome.path = chrome_bin
    end
    if chrome_driver = ENV["CHROME_DRIVER_REAL"]
      Selenium::WebDriver::Chrome::Service.driver_path = chrome_driver
    end

    link = "https://iboard.ssi.com.vn/bang-gia/chung-quyen"
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto(link)
    browser.element(css: "#CHPG2201").wait_until(&:present?)
    content = browser.element(css: "#table-body-scroll")
    data = Nokogiri::HTML(content.inner_html)
    data.css('tr').each do |cw_data|
      code, issuer, end_date, top, bottom, tc, long3, long3_vol, long2, long2_vol, long1, long1_vol, current_warrant_price, volumn, variance, short1, short1_vol, short2, short2_vol, short3, short3_vol, max, min, total_volumn, stock, current_stock_price, ignore_1, ignore_2, basic_stock_price, conversion = cw_data.css('td').map(&:text)
      cw = Warrant.find_or_create_by(code: code)
      cw.stock ||= code[1..3]
      cw.issuer ||= issuer
      cw.link ||= "https://finance.vietstock.vn/chung-khoan-phai-sinh/#{code}/cw-tong-quan.htm"
      cw.end_date ||= Date.strptime(end_date, "%d/%m/%y")
      cw.conversion = conversion.split(":")[0]
      cw.basic_stock_price = basic_stock_price.to_f * 1000
      cw.tham_chieu = tc.to_f*1000
      cw.current_warrant_price = current_warrant_price.present? ? current_warrant_price.to_f * 1000 : tc.to_f * 1000
      cw.current_stock_price = current_stock_price.to_f * 1000
      cw.save!
      today_price = cw.daily_prices.find_or_create_by(date: today)
      yesterday_price = cw.daily_prices.find_by_date(yesterday)
      today_price.yesterday_stock_price = yesterday_price&.current_stock_price
      today_price.yesterday_warrant_price = yesterday_price&.current_warrant_price
      today_price.current_warrant_price = current_warrant_price.present? ? current_warrant_price.to_f * 1000 : tc.to_f * 1000
      today_price.current_stock_price = current_stock_price.to_f * 1000
      today_price.save
      today_price.calculate
    end

    setting = Setting.first || Setting.create
    setting.update(last_run_date: Time.now)
  end
end
