class AddChecksColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :repo_order, :boolean
    add_column :users, :repo_ready, :boolean
  end
end
