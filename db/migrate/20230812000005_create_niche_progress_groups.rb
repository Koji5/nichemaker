class CreateNicheProgressGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :niche_progress_groups do |t|
      t.string :name, null: false
      t.references :niche, null: false, foreign_key: true
      t.timestamps
    end
  end
end
