class AddColumnLastLoggedOutAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_logged_out_at, :datetime
  end
end
