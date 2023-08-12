class CreatePostParameters < ActiveRecord::Migration[6.0]
  def change
    create_table :post_parameters do |t|
      t.decimal :value, null: false, precision: 10, scale: 2
      t.references :niche_parameter, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
  end
end
