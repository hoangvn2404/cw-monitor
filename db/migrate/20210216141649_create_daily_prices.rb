class CreateDailyPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_prices do |t|
      t.date :date
      t.integer :warrant_id, index: true
      t.integer :current_warrant_price
      t.integer :current_stock_price
      t.integer :volumn
      t.float :percent_need_to_increase
      t.float :percent_expired_profit
      t.float :percent_premium

      t.timestamps
    end
  end
end
