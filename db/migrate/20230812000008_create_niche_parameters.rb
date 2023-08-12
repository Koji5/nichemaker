class CreateNicheParameters < ActiveRecord::Migration[6.0]
  def change
    create_table :niche_parameters do |t|
      t.string :name, null: false
      t.string :unit
      t.references :niche, null: false, foreign_key: true
      t.timestamps
    end
  end
end
