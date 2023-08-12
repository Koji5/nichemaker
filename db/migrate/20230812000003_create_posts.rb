class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.date :posted_at, null: false
      t.integer :nice_count, null: false, default: 0
      t.integer :view_count, null: false, default: 0
      t.references :niche, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
