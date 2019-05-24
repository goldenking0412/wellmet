class AddLastChattedUserIdForUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_chatted_user_id, :integer
  end
end
