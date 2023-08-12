class CreateNiches < ActiveRecord::Migration[6.0]
  def change
    create_table :niches do |t|

      t.timestamps
    end
  end
end
