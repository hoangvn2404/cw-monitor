class RenameColummWarrent < ActiveRecord::Migration[6.1]
  def change
    rename_column :warrants, :current_warrent_price, :current_warrant_price
  end
end
