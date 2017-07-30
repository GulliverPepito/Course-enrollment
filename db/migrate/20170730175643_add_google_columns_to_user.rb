class AddGoogleColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :google_name, :string
    add_column :users, :google_email, :string
    add_column :users, :google_image, :string
    add_column :users, :google_token, :string
  end
end
