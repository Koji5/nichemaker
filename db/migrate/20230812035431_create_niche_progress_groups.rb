class CreateNicheProgressGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :niche_progress_groups do |t|

      t.timestamps
    end
  end
end
