class AddColumnDeactivateToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :deactivate, :boolean, default: false, null: false
  end
end
