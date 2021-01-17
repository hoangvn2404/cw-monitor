namespace :cw do
  task import_from_csv: :environment do
    Warrant.destroy_all
    xlsx = Roo::Spreadsheet.open('CW.xlsx')
    (2..xlsx.last_row).map do |i|
      data = xlsx.row(i)
      Warrant.create!(link: data[1].href,
                      stock: data[6],
                      issuer: data[7],
                      code: data[1],
                      conversion: data[4],
                      start_date: convert_date(data[8]),
                      end_date: convert_date(data[9]),
                      current_warrent_price: data[2],
                      basic_stock_price: data[5])
    end
  end

  task update_price: :environment do
    @progressbar = ProgressBar.create(title: 'Updating Price', starting_at: 0, total: Warrant.count)
    Warrant.all.each do |w|
      @progressbar.increment
      UpdatePriceJob.perform_later w.id
      # w.update_price
    end
  end
end

def convert_date(x)
  x.is_a?(String) ? Date.parse(x) : Date.parse(x.strftime("%m/%d/%Y"))
end