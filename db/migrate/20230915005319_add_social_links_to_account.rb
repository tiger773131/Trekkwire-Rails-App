class AddSocialLinksToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :linkedin_social, :string
    add_column :accounts, :facebook_social, :string
    add_column :accounts, :x_social, :string
    add_column :accounts, :youtube_social, :string
    add_column :accounts, :instagram_social, :string
  end
end
