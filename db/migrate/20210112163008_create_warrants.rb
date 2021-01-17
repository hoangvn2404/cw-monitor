class CreateWarrants < ActiveRecord::Migration[6.1]
  def change
    create_table :warrants do |t|
      t.string :link
      t.string :stock
      t.string :issuer
      t.string :code
      t.string :status
      t.date :start_date
      t.date :end_date
      t.integer :conversion
      t.integer :current_warrent_price
      t.integer :basic_stock_price
      t.integer :current_stock_price
      t.integer :percent_need_to_increase
      t.integer :percent_expired_profile
      t.integer :percent_premium
      t.timestamps
    end
  end
end
