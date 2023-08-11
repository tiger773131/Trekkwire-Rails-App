class AddDurationAndTaglineToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :duration, :integer
    add_column :tours, :tagline, :string
  end
end
