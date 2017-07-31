class AddNameDetailsColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :manual_first_name, :string
    add_column :users, :manual_last_name, :string
  end
end
