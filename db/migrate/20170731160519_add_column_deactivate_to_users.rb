class AddColumnDeactivateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deactivate, :boolean, default: false, null: false
  end
end
