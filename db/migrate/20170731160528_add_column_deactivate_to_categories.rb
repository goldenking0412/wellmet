class AddColumnDeactivateToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :deactivate, :boolean, default: false, null: false
  end
end
