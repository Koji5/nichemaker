class ChangeRateToAllowNullInProgressRates < ActiveRecord::Migration[6.0]
  def change
    change_column_null :progress_rates, :rate, true
  end
end
