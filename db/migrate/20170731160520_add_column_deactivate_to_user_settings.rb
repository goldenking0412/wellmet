class AddColumnDeactivateToUserSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :deactivate, :boolean, default: false, null: false
  end
end
