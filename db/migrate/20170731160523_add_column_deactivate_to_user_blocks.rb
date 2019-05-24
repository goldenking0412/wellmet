class AddColumnDeactivateToUserBlocks < ActiveRecord::Migration
  def change
    add_column :user_blocks, :deactivate, :boolean, default: false, null: false
  end
end
