class AddPolicyColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :policy, :boolean, default: false
  end
end
