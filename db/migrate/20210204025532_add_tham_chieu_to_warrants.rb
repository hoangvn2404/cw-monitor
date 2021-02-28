class AddThamChieuToWarrants < ActiveRecord::Migration[6.1]
  def change
    add_column :warrants, :tham_chieu, :integer
  end
end
