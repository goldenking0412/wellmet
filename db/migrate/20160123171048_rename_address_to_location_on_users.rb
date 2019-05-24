class RenameAddressToLocationOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :address, :location
  end
end
