# == Schema Information
#
# Table name: warrants
#
#  id                       :bigint           not null, primary key
#  link                     :string
#  stock                    :string
#  issuer                   :string
#  code                     :string
#  status                   :string
#  start_date               :date
#  end_date                 :date
#  conversion               :float
#  current_warrant_price    :integer
#  basic_stock_price        :integer
#  current_stock_price      :integer
#  percent_need_to_increase :float
#  percent_expired_profit   :float
#  percent_premium          :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  tham_chieu               :integer
#
class Warrant < ApplicationRecord
  default_scope { where('end_date >= ?', DateTime.now) }
  has_many :daily_prices

  # validates :code, presence: true, uniqueness: true

  scope :with_issuer, ->(issuer) { where(issuer: issuer) if issuer.present? }
  scope :with_stock, ->(stock) { where(stock: stock) if stock.present? }
  scope :within_watchlist, ->(value, cw_ids) { where(id: cw_ids) if cw_ids.present? && value=="1" }

  def calculate
    r = conversion
    c = current_warrant_price
    x = basic_stock_price
    s = current_stock_price
    percent_need_to_increase = (r*c+x)/s-1
    percent_expired_profit = (s-x)/(r*c)-1
    self.update(percent_need_to_increase: percent_need_to_increase, percent_expired_profit: percent_expired_profit)
  end

  def update_price
    today = Date.today
    return if today.saturday? || today.sunday?
    require 'open-uri'
    html = open link
    doc = Nokogiri::HTML html  
    current_warrant_price = doc.css('#stockprice').text.gsub(",", "").gsub(" ", "")
    current_stock_price = doc.css('#basestock').text.gsub(",", "").gsub(" ", "")
    start_date = doc.xpath("//td//b[text()='Ngày giao dịch đầu tiên']//ancestor-or-self::tr//td[2]").text.split(" : ")[0].to_date
    end_date = doc.xpath("//td//b[text()='Ngày giao dịch cuối cùng']//ancestor-or-self::tr//td[2]").text.split(" : ")[0].to_date
    basic_stock_price = self.basic_stock_price || doc.xpath("//td//b[text()='Giá thực hiện']//ancestor-or-self::tr//td[2]").text.split(" : ")[0].gsub(",", "").to_i
    issuer = doc.xpath("//td//b[text()='Tổ chức phát hành CW']//ancestor-or-self::tr//td[2]").text.split("(")[1].gsub(")", "")
    update(current_warrant_price: current_warrant_price, 
           current_stock_price: current_stock_price,
           start_date: start_date,
           basic_stock_price: basic_stock_price)

    today_price = self.daily_prices.find_or_create_by(date: today)
    today_price.current_warrant_price = current_warrant_price
    today_price.current_stock_price = current_stock_price
    today_price.save
    today_price.calculate
  end

  def update_daily_price_warrant
    require 'open-uri'
    html = open link
    doc = Nokogiri::HTML html  
    doc.css("#stock-transactions tbody tr").each do |daily_price|
      day, price, x_1, volumn, x_2, x_3, x_4, x_5 = daily_price.css("td").map(&:text)
      p = self.daily_prices.find_or_create_by(date: day)
      p.update(current_warrant_price: price.gsub(",", ""), 
               volumn: volumn.gsub(",", ""))
    end

    stock_link = doc.xpath("//td//b[text()='CK cơ sở']//ancestor-or-self::tr//td[2]/a")[0].values[1]
    html = open stock_link
    doc = Nokogiri::HTML html
    doc.css("#stock-transactions tbody tr").each do |daily_price|
      day, price, x_1, volumn, x_2, x_3, x_4, x_5 = daily_price.css("td").map(&:text)
      self.daily_prices.where(date: day).update_all(current_stock_price: price.gsub(",", ""))
    end

    self.daily_prices.each(&:calculate)
  end

  def update_daily_price_stock
    require 'open-uri'
    html = open link
    doc = Nokogiri::HTML html
    stock_link = doc.xpath("//td//b[text()='CK cơ sở']//ancestor-or-self::tr//td[2]/a")[0].values[1]
    html = open stock_link
    doc = Nokogiri::HTML html
    doc.css("#stock-transactions tbody tr").each do |daily_price|
      day, price, x_1, volumn, x_2, x_3, x_4, x_5 = daily_price.css("td").map(&:text)
      self.daily_prices.where(date: day).update_all(current_stock_price: price.gsub(",", ""))
    end

    self.daily_prices.each(&:calculate)
  end
end



