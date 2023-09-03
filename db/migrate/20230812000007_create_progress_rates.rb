class CreateProgressRates < ActiveRecord::Migration[6.0]
  def change
    create_table :progress_rates do |t|
      t.float :rate, null: false
      t.references :niche_progress_task, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
  end
end
