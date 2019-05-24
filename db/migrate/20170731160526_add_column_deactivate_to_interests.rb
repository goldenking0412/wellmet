class AddColumnDeactivateToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :deactivate, :boolean, default: false, null: false
  end
end
