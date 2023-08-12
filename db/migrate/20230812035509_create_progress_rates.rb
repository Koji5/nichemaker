class CreateProgressRates < ActiveRecord::Migration[6.0]
  def change
    create_table :progress_rates do |t|

      t.timestamps
    end
  end
end
