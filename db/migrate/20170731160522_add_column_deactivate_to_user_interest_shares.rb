class AddColumnDeactivateToUserInterestShares < ActiveRecord::Migration
  def change
    add_column :user_interest_shares, :deactivate, :boolean, default: false, null: false
  end
end
