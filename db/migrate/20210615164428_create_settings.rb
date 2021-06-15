class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.datetime :last_run_date

      t.timestamps
    end
  end
end
