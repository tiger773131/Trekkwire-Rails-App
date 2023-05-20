class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.string :title
      t.text :description
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
