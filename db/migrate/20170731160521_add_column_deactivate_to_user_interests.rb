class AddColumnDeactivateToUserInterests < ActiveRecord::Migration
  def change
    add_column :user_interests, :deactivate, :boolean, default: false, null: false
  end
end
