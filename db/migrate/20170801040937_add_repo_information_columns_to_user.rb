class AddRepoInformationColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :repo_url, :string
    add_column :users, :repo_name, :string
  end
end
