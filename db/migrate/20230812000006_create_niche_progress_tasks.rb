class CreateNicheProgressTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :niche_progress_tasks do |t|
      t.string :name, null: false
      t.references :niche_progress_group, null: false, foreign_key: true
      t.timestamps
    end
  end
end
