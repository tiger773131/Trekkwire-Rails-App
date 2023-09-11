class CreateAccountLanguageTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :account_language_taggings do |t|
      t.belongs_to :language_tag, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
