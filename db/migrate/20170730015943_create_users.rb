class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :github_nickname
      t.string :github_name
      t.string :github_email
      t.string :github_image_url
      t.string :github_token

      t.timestamps
    end
  end
end
