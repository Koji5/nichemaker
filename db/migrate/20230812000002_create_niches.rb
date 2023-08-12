class CreateNiches < ActiveRecord::Migration[6.0]
  def change
    create_table :niches do |t|
      t.string :title, null: false
      t.text :info, null: false
      t.string :admin_name, null: false
      t.integer :progress_setting, null: false
      t.integer :parameter_setting, null: false
      t.integer :tag_setting, null: false
      t.integer :nice_setting, null: false
      t.integer :publish_range, null: false
      t.integer :topic_range, null: false
      t.integer :comment_range, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
