class AddInterestIdForUserInterestShares < ActiveRecord::Migration
  def change
    add_column :user_interest_shares, :interest_id, :integer, null: false
    remove_column :user_interest_shares, :user_interest_id
    add_column :user_interest_shares, :to_user_id, :integer, null: false
  end
end
