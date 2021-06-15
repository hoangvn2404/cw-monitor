class AddIssuedPriceToWarrant < ActiveRecord::Migration[6.1]
  def change
    add_column :warrants, :issued_price, :integer
    add_column :daily_prices, :gearing_ratio, :float
  end
end
