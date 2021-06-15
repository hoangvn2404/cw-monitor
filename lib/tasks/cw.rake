namespace :cw do
  task update_yester_price: :environment do
    days = DailyPrice.order(date: :desc).pluck(:date).uniq.take(5).reverse
    days.each_with_index do |today, index|
      next if index.zero?
      yesterday = days[index-1]
      DailyPrice.includes(warrant: :daily_prices).where(date: today).each do |price|
        next if price.warrant.blank?
        yesterday_price = price.warrant.daily_prices.find_by_date(yesterday)  
        next if yesterday_price.blank?
        price.update(yesterday_stock_price: yesterday_price.current_stock_price,
                     yesterday_warrant_price: yesterday_price.current_warrant_price)
        price.calculate
      end
    end
  end

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
      Setting.parse_from_vndirect      
    rescue Exception => e
      progressbar = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', total: Warrant.count)
      Warrant.all.each do |w|
        UpdatePriceJob.perform_later w.id
        progressbar.increment
      end  
    end
  end
end

