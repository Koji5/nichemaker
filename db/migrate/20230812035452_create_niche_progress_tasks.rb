class CreateNicheProgressTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :niche_progress_tasks do |t|

      t.timestamps
    end
  end
end
