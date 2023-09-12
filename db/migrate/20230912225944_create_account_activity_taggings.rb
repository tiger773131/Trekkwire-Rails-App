class CreateAccountActivityTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :account_activity_taggings do |t|
      t.belongs_to :activity_tag, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
