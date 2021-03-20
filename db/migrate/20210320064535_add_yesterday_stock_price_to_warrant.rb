class AddYesterdayStockPriceToWarrant < ActiveRecord::Migration[6.1]
  def change
    add_column :daily_prices, :yesterday_stock_price, :integer
    add_column :daily_prices, :yesterday_warrant_price, :integer
    add_column :daily_prices, :change_in_warrant, :float
    add_column :daily_prices, :change_in_stock, :float
  end
end
