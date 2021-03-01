namespace :cw do
  task update_daily_price_warrant: :environment do
    progressbar = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', total: Warrant.count)
    Warrant.all.each do |w|
      w.update_daily_price_warrant
      progressbar.increment
    end
  end

  task update_daily_price_stock: :environment do
    progressbar = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', total: Warrant.count)
    Warrant.all.each do |w|
      w.update_daily_price_stock
      progressbar.increment
    end
  end

  task update_price: :environment do
    # parse_from_vndirect      
    # progressbar = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', total: Warrant.count)
    # Warrant.all.each do |w|
    #   UpdatePriceJob.perform_later w.id
    #   progressbar.increment
    # end  
    begin
      parse_from_vndirect      
    rescue Exception => e
      progressbar = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', total: Warrant.count)
      Warrant.all.each do |w|
        UpdatePriceJob.perform_later w.id
        progressbar.increment
      end  
    end
  end
end

def parse_from_vndirect

  today = Date.today
  return if today.saturday? || today.sunday?

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
  browser.element(css: "#CEIB2001").wait_until(&:present?)

  content = browser.element(css: "#banggia-chungquyen-body")
  data = Nokogiri::HTML(content.inner_html)
  data.css('tr').each do |cw_data|
    code, issuer, end_date, tc, top, bottom, total_volumn, long3, long3_vol, long2, long2_vol, long1, long1_vol, current_warrant_price, volumn, variance, short1, short1_vol, short2, short2_vol, short3, short3_vol, ignore, current_stock_price, basic_stock_price, conversion = cw_data.css('td').map(&:text)
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
    today_price.current_warrant_price = current_warrant_price.present? ? current_warrant_price.to_f * 1000 : tc.to_f * 1000
    today_price.current_stock_price = current_stock_price.to_f * 1000
    today_price.save
    today_price.calculate
  end  
end