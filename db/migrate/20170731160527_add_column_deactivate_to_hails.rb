class AddColumnDeactivateToHails < ActiveRecord::Migration
  def change
    add_column :hails, :deactivate, :boolean, default: false, null: false
  end
end
