class AddTaglineToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :tagline, :string
  end
end
